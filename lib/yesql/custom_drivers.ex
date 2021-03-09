defmodule CustomDrivers do
  @moduledoc """
    Load standard drivers Postgrex and Ecto or
    alternatively load driver modules according to config
    (all drivers need to be specified).
    In config, specify :yesql :supported_drivers as list:
    e.g.:

    config :yesql,
    custom_yesql_drivers: [Mssqlex]
  """

  Module.register_attribute(Yesql, :supported_drivers, accumulate: true)

  defmacro __using__(_opts) do
    case Application.fetch_env(:yesql, :custom_yesql_drivers) do
      :error ->
        Module.put_attribute(Yesql, :supported_drivers, Postgrex)
        Module.put_attribute(Yesql, :supported_drivers, Mssqlex)

      {:ok, driver_list} ->
        IO.inspect(driver_list)

        for driver <- driver_list do
          IO.puts("Adding driver to supported driver: #{driver}")
          Module.put_attribute(Yesql, :supported_drivers, driver)
        end
    end
  end
end
