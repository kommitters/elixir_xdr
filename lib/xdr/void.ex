defmodule XDR.Void do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of manage the Void types based on the RFC4506 XDR Standard
  """

  defstruct void: nil

  @typedoc """
  the void type contains the value of the void it must be void or binary
  """
  @type t :: %XDR.Void{void: nil | binary()}

  alias XDR.Error.Void

  @doc """
  this function provides an easy way to create a new void type, it receives the value and create a new XDR.Void structure

  returns an XDR.Void structure
  """
  @spec new(any) :: t()
  def new(void), do: %XDR.Void{void: void}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the void values into an XDR format, it receives an XDR.Void structure which contains
  the void value

  returns and ok tuple with the resulted XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.Void{void: value}) when not is_nil(value), do: raise(Void, :not_void)
  def encode_xdr(%XDR.Void{void: nil}), do: {:ok, <<>>}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the void values into an XDR format, it receives an XDR.Void structure which contains
  the void value

  returns the resulted XDR
  """
  @spec encode_xdr!(t()) :: binary
  def encode_xdr!(%XDR.Void{void: nil}), do: <<>>

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the void values into an vo format, it receives an XDR.Void structure which contains
  the void value

  returns and ok tuple with the resulted void
  """
  @spec decode_xdr(t()) :: {:ok, {nil, binary}}
  def decode_xdr(%XDR.Void{void: binary}) when not is_binary(binary), do: raise(Void, :not_binary)
  def decode_xdr(%XDR.Void{void: <<>>}), do: {:ok, {nil, ""}}

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the void values into an vo format, it receives an XDR.Void structure which contains
  the void value

  returns the resulted void
  """
  @spec decode_xdr!(t()) :: {nil, binary}
  def decode_xdr!(void), do: decode_xdr(void) |> elem(1)
end
