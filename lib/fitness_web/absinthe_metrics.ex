defmodule FitnessWeb.AbsintheMetrics do
  require Logger

  def setup do
    # Attach to the existing Absinthe telemetry events
    :telemetry.attach_many(
      :absinthe_telemetry,
      [
        [:absinthe, :execute, :operation, :start],
        [:absinthe, :execute, :operation, :stop],
        [:absinthe, :resolve, :field, :start],
        [:absinthe, :resolve, :field, :stop],
        [:absinthe, :resolve, :field, :exception]
      ],
      &handle_event/4,
      nil
    )

    Logger.info("Absinthe telemetry handlers attached")
  end

  # Operation events
  defp handle_event([:absinthe, :execute, :operation, :start], _measurements, metadata, _config) do
    operation_type = metadata.operation.operation || "unknown"
    operation_name = metadata.operation.name || "anonymous"

    Logger.warning("[GraphQL] Starting operation: #{operation_type} #{operation_name}")
  end

  defp handle_event([:absinthe, :execute, :operation, :stop], measurements, metadata, _config) do
    operation_type = metadata.operation.operation || "unknown"
    operation_name = metadata.operation.name || "anonymous"
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)

    Logger.warning("[GraphQL] Completed operation: #{operation_type} #{operation_name} in #{duration_ms}ms")
  end

  # Field resolution events
  defp handle_event([:absinthe, :resolve, :field, :start], _measurements, _metadata, _config) do
    # Skip logging field starts to reduce noise
    :ok
  end

  defp handle_event([:absinthe, :resolve, :field, :stop], measurements, metadata, _config) do
    object_type = metadata.object.identifier
    field_name = metadata.field.name
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)

    # Focus on key resolvers and slow resolvers
    cond do
      # Critical resolvers that we always want to log
      {object_type, field_name} == {:workout_template, :workout_items} ->
        Logger.warning("[GraphQL] Resolved workout_items for template in #{duration_ms}ms")

      {object_type, field_name} == {:workout_item, :exercise} ->
        Logger.warning("[GraphQL] Resolved exercise for workout_item in #{duration_ms}ms")

      # Slow resolvers
      duration_ms > 50 ->
        Logger.warning("[GraphQL] Slow resolver: #{object_type}.#{field_name} took #{duration_ms}ms")

      # Skip logging fast resolvers
      true ->
        :ok
    end
  end

  defp handle_event([:absinthe, :resolve, :field, :exception], _measurements, metadata, _config) do
    object_type = metadata.object.identifier
    field_name = metadata.field.name
    error = inspect(metadata.reason)

    Logger.warning("[GraphQL] Error resolving #{object_type}.#{field_name}: #{error}")
  end
end
