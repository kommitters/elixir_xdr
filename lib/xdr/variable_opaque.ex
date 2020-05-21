defmodule XDR.VariableOpaque do
  @behaviour XDR.Declaration
  @moduledoc """
  This module is in charge of process the Variable length opaque based on the RFC4506 XDR Standard
  """

  defstruct opaque: nil, max_size: nil

  @typedoc """
  Every double float structure has a float which represent the Double-Precision Floating-Point value which you try to encode
  """
  @type t :: %XDR.VariableOpaque{opaque: binary() | nil, max_size: integer()}

  alias XDR.{FixedOpaque, UInt}
  alias XDR.Error.VariableOpaque, as: VariableOpaqueErr

  @doc """
  this function provides an easy way to create an XDR.VariableOpaque type

  returns a XDR.VariableOpaque struct with the value received as parameter
  """
  @spec new(opaque :: binary | nil, max_size :: integer) :: t()
  def new(opaque, max_size \\ 4_294_967_295)
  def new(opaque, max_size), do: %XDR.VariableOpaque{opaque: opaque, max_size: max_size}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode the variable length opaque into an XDR,it receives an XDR.VariableOpaque stucture
  which contains the needed data to encode the opaque

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(map()) ::
          {:ok, binary}
          | {:error,
             :not_binary
             | :not_number
             | :exceed_lower_bound
             | :exceed_upper_bound
             | :invalid_length}
  def encode_xdr(%{opaque: opaque}) when not is_binary(opaque),
    do: {:error, :not_binary}

  def encode_xdr(%{max_size: max_size}) when not is_integer(max_size),
    do: {:error, :not_number}

  def encode_xdr(%{max_size: max_size}) when max_size <= 0,
    do: {:error, :exceed_lower_bound}

  def encode_xdr(%{max_size: max_size}) when max_size > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def encode_xdr(%{opaque: opaque, max_size: max_size})
      when byte_size(opaque) > max_size,
      do: {:error, :invalid_length}

  def encode_xdr(%{opaque: opaque}) do
    length = byte_size(opaque)

    opaque_length =
      length
      |> UInt.new()
      |> UInt.encode_xdr!()

    fixed_opaque =
      FixedOpaque.new(opaque, length)
      |> FixedOpaque.encode_xdr!()

    {:ok, opaque_length <> fixed_opaque}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode the variable length opaque into an XDR,it receives an XDR.VariableOpaque stucture
  which contains the needed data to encode the opaque

  returns the resulted XDR
  """
  @spec encode_xdr!(map()) :: binary
  def encode_xdr!(opaque) do
    case encode_xdr(opaque) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(VariableOpaqueErr, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode the XDR into a variable length opaque,it receives an XDR.VariableOpaque stucture
  which contains the needed data to decode the opaque

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr(bytes :: binary, opts :: map()) ::
          {:ok, {t, binary}}
          | {:error,
             :not_binary
             | :not_number
             | :exceed_lower_bound
             | :exceed_upper_bound
             | :length_over_max
             | :length_over_rest}
  def decode_xdr(bytes, opts \\ %{max_size: 4_294_967_295})

  def decode_xdr(bytes, _opts) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(_bytes, %{max_size: max_size}) when not is_integer(max_size),
    do: {:error, :not_number}

  def decode_xdr(_bytes, %{max_size: max_size}) when max_size <= 0,
    do: {:error, :exceed_lower_bound}

  def decode_xdr(_bytes, %{max_size: max_size}) when max_size > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def decode_xdr(bytes, %{max_size: max_size}) do
    {uint, rest} = UInt.decode_xdr!(bytes)

    get_decoded_value({uint.datum, rest}, max_size)
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode the XDR into a variable length opaque,it receives an XDR.VariableOpaque stucture
  which contains the needed data to decode the opaque

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr!(bytes :: binary, opts :: map()) :: {t, binary}
  def decode_xdr!(bytes, struct \\ %{max_size: 4_294_967_295})

  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(VariableOpaqueErr, reason)
    end
  end

  @spec get_decoded_value({integer(), binary()}, max :: integer()) :: {:ok, {t, binary}}
  defp get_decoded_value({length, _rest}, max) when length > max,
    do: {:error, :length_over_max}

  defp get_decoded_value({length, rest}, _max) when length > byte_size(rest),
    do: {:error, :length_over_rest}

  defp get_decoded_value({length, rest}, max) do
    {fixed_opaque, rest} = FixedOpaque.decode_xdr!(rest, %XDR.FixedOpaque{length: length})

    decoded_variable_array =
      fixed_opaque.opaque
      |> new(max)

    {:ok, {decoded_variable_array, rest}}
  end
end
