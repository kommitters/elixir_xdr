defmodule XDR.String do
  @moduledoc """
  this module is in charge of process the  String types based on the RFC4056 XDR Standard
  """

  alias XDR.VariableOpaque
  alias XDR.Error.String, as: StringErr

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode an string into an XDR format

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(value :: String.t(), _opts :: any) :: {:ok, binary}
  def encode_xdr(value, _opts \\ nil)
  def encode_xdr(value, _opts) when not is_bitstring(value), do: raise(StringErr, :not_bitstring)

  def encode_xdr(value, _opts) do
    length = byte_size(value)
    {:ok, VariableOpaque.encode_xdr!(value, length)}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode an string into an XDR format

  returns the resulted XDR
  """
  @spec encode_xdr!(value :: String.t(), _opts :: any) :: binary
  def encode_xdr!(value, _opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string

  returns an :ok tuple with the resulted string
  """
  @spec decode_xdr(binary, opts :: any()) :: {:ok, {String.t(), binary()}}
  def decode_xdr(bytes, max_length \\ 4_294_967_295)

  def decode_xdr(bytes, max_length) do
    {binary, rest} = VariableOpaque.decode_xdr!(bytes, max_length)

    string =
      binary
      |> String.graphemes()
      |> Enum.join("")

    {:ok, {string, rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a string

  returns the resulted string
  """
  @spec decode_xdr!(binary, opts :: any()) :: {String.t(), binary()}
  def decode_xdr!(bytes, max_length \\ 4_294_967_295)
  def decode_xdr!(bytes, max_length), do: decode_xdr(bytes, max_length) |> elem(1)
end
