defmodule XDR.Bool do
  @moduledoc """
  This module is in charge of process the boolean types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.Bool
  alias XDR.Enum

  @boolean %Enum{declarations: [false: 0, true: 1]}

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

    ## Parameters:
      - value: represents the boolean which you need to encode
      - opts: it is an optional value required by the behaviour

    returns an ok tuple with the boolean encoded into an XDR value
  """
  @spec encode_xdr(boolean(), any) :: {:ok, binary()}
  def encode_xdr(value, _opts \\ nil)
  def encode_xdr(value, _opts) when not is_boolean(value), do: raise(Bool, :not_boolean)
  def encode_xdr(value, _opts), do: XDR.Enum.encode_xdr(@boolean, value)

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode the boolean data to a binary representation

    ## Parameters:
      - value: represents the boolean which you need to encode
      - opts: it is an optional value required by the behaviour

    returns the boolean encoded into an XDR value
  """
  @spec encode_xdr!(boolean(), any) :: binary()
  def encode_xdr!(value, _opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

    ## Parameters:
      - bytes: represents the XDR value which represents the boolean value into @boolean
      - opts: it is an optional value required by the behaviour

    returns an ok tuple with the boolean decoded from an XDR value
  """
  @spec decode_xdr(binary(), any) :: {:ok, {boolean(), binary}}
  def decode_xdr(bytes, _opts \\ nil)
  def decode_xdr(bytes, _opts), do: XDR.Enum.decode_xdr(bytes, @boolean)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode XDR data which represents a boolean value

    ## Parameters:
      - bytes: represents the XDR value which represents the boolean value into @boolean
      - opts: it is an optional value required by the behaviour

    returns the boolean decoded from an XDR value
  """
  @spec decode_xdr!(binary(), any) :: {boolean(), binary}
  def decode_xdr!(bytes, _opts \\ nil)
  def decode_xdr!(bytes, _opts), do: XDR.Enum.decode_xdr!(bytes, @boolean)
end
