defmodule XDR.Void do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of manage the Void types based on the RFC4506 XDR Standard
  """

  defstruct void: nil

  @typedoc """
  the void type contains the value of the void it must be void or binary
  """
  @type t :: %XDR.Void{void: binary | nil}

  alias XDR.Error.Void

  @doc """
  this function provides an easy way to create a new void type, it receives the value and create a new XDR.Void structure

  returns an XDR.Void structure
  """
  @spec new(nil) :: t()
  def new(value), do: %XDR.Void{void: value}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the void values into an XDR format, it receives an XDR.Void structure which contains
  the void value

  returns and ok tuple with the resulted XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary} | {:error, :not_void}
  def encode_xdr(%XDR.Void{void: nil}), do: {:ok, <<>>}
  def encode_xdr(_), do: {:error, :not_void}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encoding the void values into an XDR format, it receives an XDR.Void structure which contains
  the void value

  returns the resulted XDR
  """
  @spec encode_xdr!(t()) :: binary
  def encode_xdr!(%XDR.Void{void: nil}), do: <<>>
  def encode_xdr!(_), do: raise(Void, :not_void)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the void values into an vo format, it receives an XDR.Void structure which contains
  the void value

  returns and ok tuple with the resulted void
  """
  @spec decode_xdr(binary, any) :: {:ok, {nil, binary}} | {:error, :not_void}
  def decode_xdr(<<>>, _), do: {:ok, {nil, ""}}
  def decode_xdr(_, _), do: {:error, :not_void}
  @impl XDR.Declaration
  @doc """
  this function is in charge of decoding the void values into an vo format, it receives an XDR.Void structure which contains
  the void value

  returns the resulted void
  """
  @spec decode_xdr!(binary, any) :: {nil, binary}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(<<>>, _), do: {nil, ""}
  def decode_xdr!(_, _), do: raise(Void, :not_void)
end
