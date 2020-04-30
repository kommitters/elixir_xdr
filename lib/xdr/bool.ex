defmodule XDR.Bool do
  @moduledoc """
  This module is in charge of process the boolean types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.Bool
  alias XDR.Enum

  @boolean %Enum{declarations: [false: 0, true: 1]}

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @spec encode_xdr(boolean(), any) :: {:ok, binary()}
  def encode_xdr(identifier, _opts \\ nil)
  def encode_xdr(identifier, _opts) when not is_boolean(identifier), do: raise(Bool, :not_boolean)
  def encode_xdr(identifier, _opts), do: XDR.Enum.encode_xdr(@boolean, identifier)

  @impl XDR.Declaration
  @spec encode_xdr!(boolean(), any) :: binary()
  def encode_xdr!(identifier, _opts \\ nil)
  def encode_xdr!(identifier, _opts), do: encode_xdr(identifier) |> elem(1)

  @impl XDR.Declaration
  @spec decode_xdr(binary(), any) :: {:ok, {boolean(), binary}}
  def decode_xdr(bytes, _opts \\ nil)
  def decode_xdr(bytes, _opts), do: XDR.Enum.decode_xdr(bytes, @boolean)

  @impl XDR.Declaration
  @spec decode_xdr!(binary(), any) :: {boolean(), binary}
  def decode_xdr!(bytes, _opts \\ nil)
  def decode_xdr!(bytes, _opts), do: XDR.Enum.decode_xdr!(bytes, @boolean)
end
