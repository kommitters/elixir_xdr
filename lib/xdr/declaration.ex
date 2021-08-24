defmodule XDR.Declaration do
  @moduledoc """
  Behaviour definition for the types declared based on RFC4506 XDR standard.
  """

  @doc "Encode XDR for any type returns a tuple with the resulted binary value."
  @callback encode_xdr(struct()) :: {:ok, binary()} | {:error, atom()}

  @doc "Encode XDR for any type returns the resulted binary value."
  @callback encode_xdr!(struct()) :: binary() | no_return()

  @doc "Encode XDR for any type returns a tuple with the converted value."
  @callback decode_xdr(binary(), term()) :: {:ok, {term(), binary()}} | {:error, atom()}

  @doc "Decode XDR for any type returns the resulted converted value."
  @callback decode_xdr!(binary(), term()) :: {term(), binary()} | no_return()
end
