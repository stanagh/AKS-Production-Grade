resource "azurerm_monitor_action_group" "alerts" {
  name                = "ag-${var.name}"
  resource_group_name = var.resource_group_name
  short_name          = "aksalerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "aks_high_cpu" {
  name                = "aks-high-cpu-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [var.log_analytics_workspace_id]
  severity             = 2
  enabled              = true

  criteria {
    query                   = <<-QUERY
      Perf
      | where ObjectName == "K8SNode"
      | where CounterName == "cpuUsageNanoCores"
      | summarize AvgCPU = avg(CounterValue) by bin(TimeGenerated, 5m)
      | where AvgCPU > 90
    QUERY
    time_aggregation_method = "Average"
    metric_measure_column   = "AvgCPU"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "aks_high_memory" {
  name                = "aks-high-memory-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [var.log_analytics_workspace_id]
  severity             = 2
  enabled              = true

  criteria {
    query                   = <<-QUERY
      Perf
      | where ObjectName == "K8SNode"
      | where CounterName == "memoryRssBytes"
      | summarize AvgMemory = avg(CounterValue) by bin(TimeGenerated, 5m)
      | where AvgMemory > 85
    QUERY
    time_aggregation_method = "Average"
    metric_measure_column   = "AvgMemory"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pod_restarts" {
  name                = "aks-pod-restarts-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [var.log_analytics_workspace_id]
  severity             = 2
  enabled              = true

  criteria {
    query                   = <<-QUERY
      KubePodInventory
      | where PodRestartCount > 5
      | summarize RestartCount = sum(PodRestartCount) by bin(TimeGenerated, 5m)
    QUERY
    time_aggregation_method = "Total"
    metric_measure_column   = "RestartCount"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "availability" {
  name                = "appi-availability-${var.name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.app_insights_id]
  severity            = 1
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }

  tags = var.tags
}