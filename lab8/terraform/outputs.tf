output "app_url" {
  value = "http://localhost:8097"
}

output "node_exporter_target" {
  value = "lab8-node-exporter:9100"
}

output "network_name" {
  value = docker_network.lab8.name
}

output "ansible_inventory" {
  value = "[local]\nlocalhost ansible_connection=local\n"
}
