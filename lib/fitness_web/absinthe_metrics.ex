defmodule FitnessWeb.AbsintheMetrics do
  require Logger

  def setup do
    :telemetry.attach_many(
      :absinthe_metrics,
      [
        [:absinthe, :execute, :operation, :start],
        [:absinthe, :execute, :operation, :stop],
        [:absinthe, :resolve, :field, :start],
        [:absinthe, :resolve, :field, :stop],
        [:dataloader, :source, :run, :start],
        [:dataloader, :source, :run, :stop]
      ],
      &handle_event/4,
      []
    )

    Logger.info("Absinthe telemetry handlers attached")
  end

  defp handle_event([:absinthe, :execute, :operation, :start], _measurements, metadata, _config) do
    operation_name = get_operation_name_from_metadata(metadata)
    Logger.warning("[GraphQL] Starting operation: #{operation_name}")
  end

  defp handle_event([:absinthe, :execute, :operation, :stop], measurements, metadata, _config) do
    operation_name = get_operation_name_from_metadata(metadata)
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    Logger.warning("[GraphQL] Completed operation: #{operation_name} in #{duration_ms}ms")
  end

  defp handle_event([:absinthe, :resolve, :field, :start], _measurements, metadata, _config) do
    field = metadata[:resolution].definition.name
    parent_type = metadata[:resolution].parent_type.identifier
    Logger.warning("[GraphQL] Resolving field: #{parent_type}.#{field}")
  end

  defp handle_event([:absinthe, :resolve, :field, :stop], measurements, metadata, _config) do
    field = metadata[:resolution].definition.name
    parent_type = metadata[:resolution].parent_type.identifier
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    Logger.warning("[GraphQL] Resolved field: #{parent_type}.#{field} in #{duration_ms}ms")
  end

  defp handle_event([:dataloader, :source, :run, :start], _measurements, metadata, _config) do
    source = metadata[:source]
    batch_key = metadata[:batch_key]

    Logger.warning(
      "[Dataloader] Running source: #{inspect(source)}, batch: #{inspect(batch_key)}"
    )
  end

  defp handle_event([:dataloader, :source, :run, :stop], measurements, metadata, _config) do
    source = metadata[:source]
    batch_key = metadata[:batch_key]
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)

    Logger.warning(
      "[Dataloader] Completed source: #{inspect(source)}, batch: #{inspect(batch_key)} in #{duration_ms}ms"
    )
  end

  defp get_operation_name_from_metadata(metadata) do
    cond do
      metadata[:params] && metadata[:params]["operationName"] ->
        metadata[:params]["operationName"]

      metadata[:options] && Keyword.get(metadata[:options], :operation_name) ->
        Keyword.get(metadata[:options], :operation_name)

      metadata[:operation] && metadata[:operation][:name] ->
        metadata[:operation][:name]

      true ->
        "anonymous"
    end
  end
end
