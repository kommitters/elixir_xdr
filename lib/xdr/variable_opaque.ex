defmodule XDR.VariableOpaque do
  alias XDR.{FixedOpaque, UInt}
  alias XDR.Error.VariableOpaque, as: VariableOpaqueErr

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode the variable length opaque into an XDR

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(binary, integer) :: {:ok, binary}
  def encode_xdr(opaque, max \\ 4_294_967_295)

  def encode_xdr(opaque, _max) when not is_binary(opaque),
    do: raise(VariableOpaqueErr, :not_binary)

  def encode_xdr(_opaque, max) when not is_integer(max), do: raise(VariableOpaqueErr, :not_number)
  def encode_xdr(_opaque, max) when max <= 0, do: raise(VariableOpaqueErr, :exceed_lower_bound)

  def encode_xdr(_opaque, max) when max > 4_294_967_295,
    do: raise(VariableOpaqueErr, :exceed_upper_bound)

  def encode_xdr(opaque, max) when byte_size(opaque) > max,
    do: raise(VariableOpaqueErr, :invalid_length)

  def encode_xdr(opaque, _max) do
    length = byte_size(opaque)
    {:ok, UInt.encode_xdr!(length) <> FixedOpaque.encode_xdr!(opaque, length)}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode the variable length opaque into an XDR

  returns the resulted XDR
  """
  @spec encode_xdr!(binary, integer) :: binary
  def encode_xdr!(opaque, max \\ 4_294_967_295)
  def encode_xdr!(opaque, max), do: encode_xdr(opaque, max) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode the XDR into a variable length opaque

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr(binary, integer) :: {:ok, {binary, binary}}
  def decode_xdr(opaque, max \\ 4_294_967_295)

  def decode_xdr(opaque, _max) when not is_binary(opaque),
    do: raise(VariableOpaqueErr, :not_binary)

  def decode_xdr(_opaque, max) when not is_integer(max), do: raise(VariableOpaqueErr, :not_number)
  def decode_xdr(_opaque, max) when max <= 0, do: raise(VariableOpaqueErr, :exceed_lower_bound)

  def decode_xdr(_opaque, max) when max > 4_294_967_295,
    do: raise(VariableOpaqueErr, :exceed_upper_bound)

  def decode_xdr(opaque, max) do
    UInt.decode_xdr!(opaque)
    |> get_decoded_value(max)
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode the XDR into a variable length opaque

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr!(binary, integer) :: {binary, binary}
  def decode_xdr!(opaque, max \\ 4_294_967_295)
  def decode_xdr!(opaque, max), do: decode_xdr(opaque, max) |> elem(1)

  defp get_decoded_value({length, _rest}, max) when length > max,
    do: raise(VariableOpaqueErr, :length_over_max)

  defp get_decoded_value({length, rest}, _max) when length > byte_size(rest),
    do: raise(VariableOpaqueErr, :length_over_rest)

  defp get_decoded_value({length, rest}, _max), do: {:ok, FixedOpaque.decode_xdr!(rest, length)}
end
