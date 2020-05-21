defmodule XDR.Optional do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of process the Optional data types based on the RFC4506 XDR Standard
  """
  alias XDR.Bool
  alias XDR.Error.Optional

  defstruct type: nil

  @typedoc """
  Every optional type contains the type of the data to process
  """
  @type t :: %XDR.Optional{type: nil | any}

  @doc """
  This function provides an easy way to create a new Optional type
  """
  @spec new(any) :: nil | t()
  def new(type), do: %XDR.Optional{type: type}

  @impl XDR.Declaration
  @doc """
  Encode Optional types

  returns an :ok tuple with the encoded XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary} | {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_bitstring(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_list(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_tuple(type), do: {:error, :not_valid}
  def encode_xdr(%{type: type}) when is_boolean(type), do: {:error, :not_valid}

  def encode_xdr(%{type: type}) when is_nil(type) do
    Bool.new(false) |> Bool.encode_xdr()
  end

  def encode_xdr(%{type: type}) do
    module = type.__struct__

    encoded_value = module.encode_xdr!(type)

    bool = Bool.new(true) |> Bool.encode_xdr!()

    {:ok, bool <> encoded_value}
  end

  @impl XDR.Declaration
  @doc """
  Encode Optional types

  returns the encoded XDR
  """
  @spec encode_xdr!(t()) :: binary
  def encode_xdr!(optional) do
    case encode_xdr(optional) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(Optional, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode Optional types

  returns an :ok tuple with the decoded type
  """
  @spec decode_xdr(bytes :: binary(), struct :: map()) ::
          {:ok, {t, binary()}} | {:error, :not_binary | :not_module}
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :not_binary}
  def decode_xdr(_bytes, %{type: type}) when not is_atom(type), do: {:error, :not_module}

  def decode_xdr(bytes, %{type: type}) do
    {bool, rest} = Bool.decode_xdr!(bytes)
    get_decoded_value(bool.identifier, rest, type)
  end

  @impl XDR.Declaration
  @doc """
  Decode Optional types

  returns the decoded type
  """
  @spec decode_xdr!(bytes :: binary(), struct :: map()) :: {t, binary()}
  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(Optional, reason)
    end
  end

  @spec get_decoded_value(boolean(), rest :: binary(), type :: atom()) ::
          {:ok, {t, binary()}} | {:ok, {nil, binary()}}
  defp get_decoded_value(true, rest, type) do
    {decoded_type, rest} = type.decode_xdr!(rest)

    optional = new(decoded_type)
    {:ok, {optional, rest}}
  end

  defp get_decoded_value(false, rest, _type), do: {:ok, {nil, rest}}
end
