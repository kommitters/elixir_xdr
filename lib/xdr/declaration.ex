defmodule XDR.Declaration do
  @moduledoc """
    Behaviour definition that is in charge of keeping the types declared by the RFC4506 standard with these specifications
  """
  alias XDR.Error

  # encode XDR for any type returns a tuple with the resulted binary value
  @callback encode_xdr(struct) :: {:ok, binary} | Error.t()

  # encode XDR for any type returns the resulted binary value
  @callback encode_xdr!(struct) :: binary | Error.t()

  # decode XDR for any type returns a tuple with the converted value
  @callback decode_xdr(struct) :: {:ok, {term, binary}} | Error.t()

  # decode XDR for any type returns the resulted converted value
  @callback decode_xdr!(struct) :: {term, binary} | Error.t()
end
