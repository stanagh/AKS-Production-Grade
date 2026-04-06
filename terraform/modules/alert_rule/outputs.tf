output "action_group_id" {
  description = "The ID of the action group."
  value       = azurerm_monitor_action_group.alerts.id
}

output "cpu_alert_id" {
  description = "The ID of the CPU alert rule."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.aks_high_cpu.id
}

output "memory_alert_id" {
  description = "The ID of the memory alert rule."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.aks_high_memory.id
}

output "pod_restarts_alert_id" {
  description = "The ID of the pod restarts alert rule."
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.pod_restarts.id
}

output "availability_alert_id" {
  description = "The ID of the availability alert rule."
  value       = azurerm_monitor_metric_alert.availability.id
}