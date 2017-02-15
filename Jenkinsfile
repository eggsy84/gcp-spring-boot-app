podTemplate(label: 'jnlp', containers: [
    containerTemplate(
          name: 'jnlp',
          image: 'eggsy84/gcp-jenkins-slave-k8s-seed:latest',
          ttyEnabled: false,
          command: '',
          privileged: true,
          alwaysPullImage: false,
          workingDir: '/home/jenkins',
          args: '${computer.jnlpmac} ${computer.name}'
        )
    ],
    volumes: [
          secretVolume(mountPath: '/opt/config', secretName: 'gcloud-svc-account'),
          hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ]
)

{

  node('jnlp') {

      // Project name will be passed in as a parameter
      def project = "${GCP_PROJECT_NAME}"
      def appName = 'spring-boot-app'

      // BUILD_DATE_TIME defined as a build parameter in Jenkins
      def imageTag = "eu.gcr.io/${project}/${appName}:${BUILD_DATE_TIME}"

      stage('Checkout') {
        checkout scm
      }

      stage('Compile') {
        sh "mvn clean compile"
      }

      stage('Test and Package') {
        sh "mvn package"
      }

      stage('Bake Docker Image') {
        sh("docker build -t ${imageTag} .")
      }

      stage('Push images to GCR') {
        sh("gcloud auth activate-service-account --key-file /opt/config/gcloud-svc-account.json")
        sh("gcloud config set project ${project}")
        sh("gcloud docker push ${imageTag}")
      }

      stage('Deploy latest version') {
        sh("sed -i.bak 's#eu.gcr.io/GCP_PROJECT/APP_NAME:1.0.0#${imageTag}#' ./k8s/deployments/*.yaml")
        sh("kubectl apply -f k8s/deployments/")
        sh("kubectl apply -f k8s/services/")
      }

      stage('Extract service IP address') {
        // Execute and wait for external service to become available
        sh("k8s/services/populate_service_address.sh")
        // Read output from script above
        def FRONTEND_ADDRESS=readFile('frontend_service_address').trim()
      }

      stage('Output service external address') {
        sh("echo 'Application up and running on'")
        sh("cat frontend_service_address")
      }
  }
}
