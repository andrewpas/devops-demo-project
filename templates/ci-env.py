CONTEXTS = {
    "adservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "adservice",
        "build_context": "/src/adservice/src",
        "autorules": "- src/adservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "cartservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "cartservice",
        "build_context": "/src/cartservice/",
        "autorules": "- src/cartservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "checkoutservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "checkoutservice",
        "build_context": "/src/checkoutservice/",
        "autorules": "- src/checkoutservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "emailservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "emailservice",
        "build_context": "/src/emailservice/",
        "autorules": "- src/emailservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "frontend": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "frontend",
        "build_context": "/src/frontend/",
        "autorules": "- src/frontend/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "loadgenerator": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "loadgenerator",
        "build_context": "/src/loadgenerator/",
        "autorules": "- src/loadgenerator/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "paymentservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "paymentservice",
        "build_context": "/src/paymentservice/",
        "autorules": "- src/paymentservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "productcatalogservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "productcatalogservice",
        "build_context": "/src/productcatalogservice/",
        "autorules": "- src/productcatalogservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "recommendationservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "recommendationservice",
        "build_context": "/src/recommendationservice/",
        "autorules": "- src/recommendationservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "shippingservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "shippingservice",
        "build_context": "/src/shippingservice/",
        "autorules": "- src/shippingservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    },
    "currencyservice": {
        "project_path": "devops1121/microservices-demo-google",
        "branch": "ci-template",
        "service": "currencyservice",
        "build_context": "/src/currencyservice/",
        "autorules": "- src/currencyservice/**/**/*",
        "environment_name": "stage",
        "environment_url": "http://stage-cluster.dvpslabs.com"
    }

}
