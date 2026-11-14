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
      | where CounterName in ("cpuUsageNanoCores", "cpuCapacityNanoCores")
      | summarize Usage = avgif(CounterValue, CounterName == "cpuUsageNanoCores"),
                  Capacity = maxif(CounterValue, CounterName == "cpuCapacityNanoCores")
                  by Computer, bin(TimeGenerated, 5m)
      | extend AvgCPU = Usage * 100.0 / Capacity
    QUERY
    time_aggregation_method = "Average"
    metric_measure_column   = "AvgCPU"
    threshold               = 90
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
      | where CounterName in ("memoryRssBytes", "memoryCapacityBytes")
      | summarize Usage = avgif(CounterValue, CounterName == "memoryRssBytes"),
                  Capacity = maxif(CounterValue, CounterName == "memoryCapacityBytes")
                  by Computer, bin(TimeGenerated, 5m)
      | extend AvgMemory = Usage * 100.0 / Capacity
    QUERY
    time_aggregation_method = "Average"
    metric_measure_column   = "AvgMemory"
    threshold               = 85
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
      | summarize Restarts = max(PodRestartCount) - min(PodRestartCount) by Name
      | summarize RestartCount = sum(Restarts)
    QUERY
    time_aggregation_method = "Total"
    metric_measure_column   = "RestartCount"
    threshold               = 3
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