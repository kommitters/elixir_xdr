defmodule XDR.Enum do
  @moduledoc """
  This module is in charge to process the Enum type based on the RFC4506 XDR Standard
  """
  alias XDR.Error.Enum, as: EnumErr

  defstruct declarations: nil

  @typedoc """
  Every enum structure has a declaration list which contains the keys and its representation value
  """
  @type t :: %XDR.Enum{declarations: list()}

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter

    ## Parameters:
      -enum: represents the enum structure which is needed to encode a key
      -name: represents the name of the key which we need to encode

  Returns a tuple with the the binary resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr(enum :: Enum.t(), name :: atom()) :: {:ok, binary()}
  def encode_xdr(enum, name \\ nil)

  def encode_xdr(%XDR.Enum{declarations: declarations}, _name) when not is_list(declarations),
    do: raise(EnumErr, :not_list)

  def encode_xdr(_enum, name) when not is_atom(name), do: raise(EnumErr, :not_an_atom)

  def encode_xdr(%XDR.Enum{declarations: declarations}, name) do
    binary =
      declarations[name]
      |> XDR.Int.encode_xdr!()

    {:ok, binary}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter

    ## Parameters:
      -enum: represents the enum structure which is needed to encode a key
      -name: represents the name of the key which we need to encode

  Returns the binary resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr!(enum :: Enum.t(), name :: atom()) :: binary()
  def encode_xdr!(enum, name \\ nil)
  def encode_xdr!(enum, name), do: encode_xdr(enum, name) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the binary which represents a value inside an enum structure

    ## Parameters:
      -bytes: represents the binary value received to decode
      -declarations: represents the enum structure which contains the value that we need to decode

  Returns a tuple with the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr(bytes :: binary(), _enum :: Enum.t()) :: {:ok, {atom(), binary()}}
  def decode_xdr(bytes, %XDR.Enum{} = _enum) when not is_binary(bytes),
    do: raise(EnumErr, :not_binary)

  def decode_xdr(_, %XDR.Enum{declarations: declarations} = _enum) when not is_list(declarations),
    do: raise(EnumErr, :not_list)

  def decode_xdr(bytes, %XDR.Enum{} = enum) do
    {value, rest} = XDR.Int.decode_xdr!(bytes)

    Enum.find(enum.declarations, &Kernel.===(elem(&1, 1), value))
    |> get_response(rest)
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the binary which represents a value inside an enum structure

    ## Parameters:
      -bytes: represents the binary value received to decode
      -declarations: represents the enum structure which contains the value that we need to decode

  Returns the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr!(bytes :: binary(), enum :: Enum.t()) :: {atom(), binary()}
  def decode_xdr!(bytes, enum), do: decode_xdr(bytes, enum) |> elem(1)

  @spec get_response({name :: atom(), any}, rest :: binary()) :: {atom(), {atom(), binary()}}
  defp get_response({name, _}, rest), do: {:ok, {name, rest}}

  @spec get_response(nil, _rest :: binary()) :: EnumErr
  defp get_response(nil, _rest), do: raise(EnumErr, :not_valid)
end
