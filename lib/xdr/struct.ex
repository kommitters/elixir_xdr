defmodule XDR.Struct do
  @moduledoc """
  This module manages the `Structure` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.StructError

  defstruct [:components]

  @typedoc """
  `XDR.Struct` structure type specification.
  """
  @type t :: %XDR.Struct{components: keyword()}

  @doc """
  Create a new `XDR.Struct` structure with the `opaque` and `length` passed.
  """
  @spec new(components :: keyword()) :: t()
  def new(components), do: %XDR.Struct{components: components}

  @doc """
  Encode a `XDR.Struct` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{components: components}) when not is_list(components), do: {:error, :not_list}
  def encode_xdr(%{components: []}), do: {:error, :empty_list}
  def encode_xdr(%{components: components}), do: {:ok, encode_components(components)}

  @doc """
  Encode a `XDR.Struct` structure into a XDR format.
  If the `struct` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(struct) do
    case encode_xdr(struct) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(StructError, reason)
    end
  end

  @doc """
  Decode the Structure in XDR format to a `XDR.Struct` structure.
  """
  @impl true
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(_bytes, %{components: components}) when not is_list(components),
    do: {:error, :not_list}

  def decode_xdr(bytes, %{components: components}) do
    {decoded_components, rest} = decode_components(bytes, components)
    decoded_struct = decoded_components |> Enum.reverse() |> new()
    {:ok, {decoded_struct, rest}}
  end

  @doc """
  Decode the Structure in XDR format to a `XDR.Struct` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(StructError, reason)
    end
  end

  @spec encode_components(components :: keyword()) :: binary()
  defp encode_components(components) do
    Enum.reduce(components, <<>>, fn {_key, component}, bytes ->
      component_module = component.__struct__
      bytes <> component_module.encode_xdr!(component)
    end)
  end

  @spec decode_components(bytes :: binary(), components :: keyword()) :: {keyword(), binary()}
  defp decode_components(bytes, components) do
    components
    |> Enum.reduce({[], bytes}, fn {key, component}, {decoded_components, rest_bytes} ->
      {decoded_component, rest} = component.decode_xdr!(rest_bytes)
      {[{key, decoded_component} | decoded_components], rest}
    end)
  end
end
