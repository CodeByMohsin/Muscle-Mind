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

  defp handle_event([:absinthe, :resolve, :field, :start], _measurements, _metadata, _config) do
    Logger.warning("[GraphQL] Field start resolving")
  end

  defp handle_event([:absinthe, :resolve, :field, :stop], measurements, _metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)

    Logger.warning("[GraphQL] Field resolved: in #{duration_ms}ms")
  end

  defp handle_event([:dataloader, :source, :run, :start], _measurements, _metadata, _config) do
    Logger.warning("[GraphQL] Field start resolving with dataloader")
  end

  defp handle_event([:dataloader, :source, :run, :stop], measurements, _metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)

    Logger.warning("[GraphQL] Field resolved: in #{duration_ms}ms")
  end

  defp get_operation_name_from_metadata(metadata) do
    cond do
      # First try params which is most reliable
      metadata[:params] && metadata[:params]["operationName"] ->
        metadata[:params]["operationName"]

      # Next try options
      metadata[:options] && Keyword.get(metadata[:options], :operation_name) ->
        Keyword.get(metadata[:options], :operation_name)

      # Finally try operation if it exists
      metadata[:operation] && metadata[:operation][:name] ->
        metadata[:operation][:name]

      # Fallback
      true ->
        "anonymous"
    end
  end
end
