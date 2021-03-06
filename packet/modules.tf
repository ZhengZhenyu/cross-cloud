module "master" {
  source                    = "./modules/master"
  name                      = "${ var.name }"
  hostname = "${ var.name }-master"
  hostname_suffix = "${ var.name }.${ var.cloud_provider }.local"
  master_node_count         = "${ var.master_node_count }"
  packet_facility           = "${ var.packet_facility }"
  packet_project_id         = "${ var.packet_project_id }"
  packet_billing_cycle      = "${ var.packet_billing_cycle }"
  packet_operating_system   = "${ var.packet_operating_system }"
  packet_master_device_plan = "${ var.packet_master_device_plan }"
  master_cloud_init = "${ module.master_templates.master_cloud_init }"
}

module "worker" {
  source                    = "./modules/worker"
  name                      = "${ var.name }"
  hostname = "${ var.name }-worker"
  hostname_suffix = "${ var.name }.${ var.cloud_provider }.local"
  worker_node_count         = "${ var.worker_node_count }"
  packet_facility           = "${ var.packet_facility }"
  packet_project_id         = "${ var.packet_project_id }"
  packet_billing_cycle      = "${ var.packet_billing_cycle }"
  packet_operating_system   = "${ var.packet_operating_system }"
  packet_worker_device_plan = "${ var.packet_worker_device_plan }"
  worker_cloud_init = "${ module.worker_templates.worker_cloud_init }"
}


module "tls" {
  source = "../tls"

  tls_ca_cert_subject_common_name = "kubernetes"
  tls_ca_cert_subject_locality = "San Francisco"
  tls_ca_cert_subject_organization = "Kubernetes"
  tls_ca_cert_subject_organization_unit = "Kubernetes" 
  tls_ca_cert_subject_province = "California"
  tls_ca_cert_subject_country = "US"
  tls_ca_cert_validity_period_hours = 1000
  tls_ca_cert_early_renewal_hours = 100

  tls_admin_cert_subject_common_name = "admin"
  tls_admin_cert_subject_locality = "San Francisco"
  tls_admin_cert_subject_organization = "system:masters"
  tls_admin_cert_subject_organization_unit = "Kubernetes"
  tls_admin_cert_subject_province = "Callifornia"
  tls_admin_cert_subject_country = "US"
  tls_admin_cert_validity_period_hours = 1000
  tls_admin_cert_early_renewal_hours = 100
  tls_admin_cert_ip_addresses = "127.0.0.1"
  tls_admin_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_apiserver_cert_subject_common_name = "kubernetes"
  tls_apiserver_cert_subject_locality = "San Francisco"
  tls_apiserver_cert_subject_organization = "Kubernetes"
  tls_apiserver_cert_subject_organization_unit = "Kubernetes"
  tls_apiserver_cert_subject_province = "California"
  tls_apiserver_cert_subject_country = "US"
  tls_apiserver_cert_validity_period_hours = "1000"
  tls_apiserver_cert_early_renewal_hours = "100"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,100.64.0.1,${ var.dns_service_ip }"
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ var.name }.${ var.cloud_provider }.local"

  tls_controller_cert_subject_common_name = "system:kube-controller-manager"
  tls_controller_cert_subject_locality = "San Francisco"
  tls_controller_cert_subject_organization = "system:kube-controller-manager"
  tls_controller_cert_subject_organization_unit = "Kubernetes"
  tls_controller_cert_subject_province = "California"
  tls_controller_cert_subject_country = "US"
  tls_controller_cert_validity_period_hours = "1000"
  tls_controller_cert_early_renewal_hours = "100"
  tls_controller_cert_ip_addresses = "127.0.0.1"
  tls_controller_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local" 
  

  tls_scheduler_cert_subject_common_name = "system:kube-scheduler"
  tls_scheduler_cert_subject_locality = "San Francisco"
  tls_scheduler_cert_subject_organization = "system:kube-scheduler"
  tls_scheduler_cert_subject_organization_unit = "Kubernetes"
  tls_scheduler_cert_subject_province = "California"
  tls_scheduler_cert_subject_country = "US"
  tls_scheduler_cert_validity_period_hours = "1000"
  tls_scheduler_cert_early_renewal_hours = "100"
  tls_scheduler_cert_ip_addresses = "127.0.0.1"
  tls_scheduler_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local" 
  

  tls_kubelet_cert_subject_common_name = "kubernetes"
  tls_kubelet_cert_subject_locality = "San Francisco"
  tls_kubelet_cert_subject_organization = "Kubernetes"
  tls_kubelet_cert_subject_organization_unit = "Kubernetes"
  tls_kubelet_cert_subject_province = "California"
  tls_kubelet_cert_subject_country = "US"
  tls_kubelet_cert_validity_period_hours = "1000"
  tls_kubelet_cert_early_renewal_hours = "100"
  tls_kubelet_cert_ip_addresses = "127.0.0.1"
  tls_kubelet_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.${ var.name }.${ var.cloud_provider }.local" 


  tls_proxy_cert_subject_common_name = "system:kube-proxy"
  tls_proxy_cert_subject_locality = "San Francisco"
  tls_proxy_cert_subject_organization = "system:node-proxier"
  tls_proxy_cert_subject_organization_unit = "Kubernetes"
  tls_proxy_cert_subject_province = "California"
  tls_proxy_cert_subject_country = "US"
  tls_proxy_cert_validity_period_hours = "1000"
  tls_proxy_cert_early_renewal_hours = "100"
  tls_proxy_cert_ip_addresses = "127.0.0.1"
  tls_proxy_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local" 

}


module "master_templates" {
  source = "/cncf/master_templates-v1.13.0-ubuntu"

  name = "${ var.name }"
  arch = "${ var.arch }"

  hostname = ""
  hostname_suffix = ""
  hostname_path = "/etc/ignore_hostname"

  master_node_count = "${ var.master_node_count }"
  etcd_endpoint     = "etcd.${ var.name }.${ var.cloud_provider }.local"
  etcd_discovery    = "${ var.name }.${ var.cloud_provider }.local"

  etcd_artifact = "${ var.etcd_artifact }"
  kube_apiserver_artifact = "${ var.kube_apiserver_artifact }"
  kube_controller_manager_artifact = "${ var.kube_controller_manager_artifact }"
  kube_scheduler_artifact = "${ var.kube_scheduler_artifact }"

  cloud_provider = ""
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  pod_cidr = "${ var.pod_cidr }"
  service_cidr = "${ var.service_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"

  ca = "${ module.tls.ca }"
  ca_key = "${ module.tls.ca_key }"
  apiserver = "${ module.tls.apiserver }"
  apiserver_key = "${ module.tls.apiserver_key }"
  controller = "${ module.tls.controller }"
  controller_key = "${ module.tls.controller_key }"
  scheduler = "${ module.tls.scheduler }"
  scheduler_key = "${ module.tls.scheduler_key }"
  cloud_config_file = ""

  dns_conf = "${ module.dns.dns_conf }"
  dns_dhcp = ""

}

module "worker_templates" {
  source = "../worker_templates-v1.13.0-ubuntu"

  hostname = ""
  hostname_suffix = ""
  hostname_path = "/etc/ignore_hostname"

  worker_node_count = "${ var.worker_node_count }"

  kubelet_artifact = "${ var.kubelet_artifact }"
  cni_artifact = "${ var.cni_artifact }"
  cni_plugins_artifact = "${ var.cni_plugins_artifact }"
  kube_proxy_image = "${ var.kube_proxy_image }"
  kube_proxy_tag = "${ var.kube_proxy_tag }"

  cloud_provider = ""
  cloud_config = "${ var.cloud_config }"
  cluster_domain = "${ var.cluster_domain }"
  pod_cidr = "${ var.pod_cidr }"
  non_masquerade_cidr = "${ var.non_masquerade_cidr }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_lb_ip      = "internal-master.${ var.name }.${ var.cloud_provider }.local"

  ca = "${ module.tls.ca }"
  kubelet = "${ module.tls.kubelet }"
  kubelet_key = "${ module.tls.kubelet_key }"
  proxy = "${ module.tls.proxy }"
  proxy_key = "${ module.tls.proxy_key }"
  bootstrap = "${ module.master_templates.bootstrap }"
  cloud_config_file = ""

  dns_conf = "${ module.dns.dns_conf }"
  dns_dhcp = ""

}

module "dns" {
  source = "../dns-etcd"
  
  name = "${ var.name }"
  etcd_server = "${ var.etcd_server }"
  discovery_nameserver = "${ var.discovery_nameserver }"
  upstream_dns = "DNS=147.75.207.207"
  cloud_provider = "${ var.cloud_provider }"

  master_ips = "${ module.master.master_ips }"
  public_master_ips = "${ module.master.public_master_ips }"
  worker_ips = "${ module.worker.worker_ips }"

  master_node_count = "${ var.master_node_count }"
  worker_node_count = "${ var.worker_node_count }"

}

module "kubeconfig" {
  source = "../kubeconfig"
  data_dir = "${ var.data_dir }"
  endpoint = "master.${ var.name }.${ var.cloud_provider }.local"
  name = "${ var.name }"
  ca = "${ module.tls.ca}"
  client = "${ module.tls.admin }"
  client_key = "${ module.tls.admin_key }"

}
