defmodule XDR.Optional do
  @moduledoc """
  This module manages the `Optional-Data` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.{Bool, OptionalError}

  defstruct [:type]

  @typedoc """
  `XDR.Optional` structure type specification.
  """
  @type t :: %XDR.Optional{type: any()}

  @doc """
  Create a new `XDR.Optional` structure with the `type` passed.
  """
  @spec new(type :: any()) :: t()
  def new(type), do: %XDR.Optional{type: type}

  @doc """
  Encode a `XDR.Optional` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{type: type}) when is_bitstring(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_list(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_tuple(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_boolean(type), do: {:error, :not_valid}
  def encode_xdr(%{type: nil}), do: false |> Bool.new() |> Bool.encode_xdr()

  def encode_xdr(%{type: type}) do
    module = type.__struct__
    encoded_value = module.encode_xdr!(type)
    bool = true |> Bool.new() |> Bool.encode_xdr!()
    {:ok, bool <> encoded_value}
  end

  @doc """
  Encode a `XDR.Optional` structure into a XDR format.
  If the `optional` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(optional) do
    case encode_xdr(optional) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(OptionalError, reason)
    end
  end

  @doc """
  Decode the Optional-Data in XDR format to a `XDR.Optional` structure.
  """
  @impl true
  def decode_xdr(bytes, _optional) when not is_binary(bytes), do: {:error, :not_binary}
  def decode_xdr(_bytes, %{type: type}) when not is_atom(type), do: {:error, :not_module}

  def decode_xdr(bytes, %{type: type}) do
    {bool, rest} = Bool.decode_xdr!(bytes)
    get_decoded_value(bool.identifier, rest, type)
  end

  @doc """
  Decode the Optional-Data in XDR format to a `XDR.Optional` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, optional) do
    case decode_xdr(bytes, optional) do
      {:ok, result} -> result
      {:error, reason} -> raise(OptionalError, reason)
    end
  end

  @spec get_decoded_value(has_optional_value :: boolean(), rest :: binary(), type :: atom()) ::
          {:ok, {t, binary()}} | {:ok, {nil, binary()}}
  defp get_decoded_value(true, rest, type) do
    {decoded_type, rest} = type.decode_xdr!(rest)
    optional = new(decoded_type)
    {:ok, {optional, rest}}
  end

  defp get_decoded_value(false, rest, _type), do: {:ok, {nil, rest}}
end
