defmodule XDR.Enum do
  @moduledoc """
  This module is in charge to process the Enum type based on the RFC4506 XDR Standard
  """

  @behaviour XDR.Declaration

  alias XDR.Error.Enum, as: EnumErr

  defstruct declarations: nil, identifier: nil

  @typedoc """
  Every enum structure has a declaration list which contains the keys and its representation value
  """
  @type t :: %XDR.Enum{declarations: keyword(), identifier: atom() | binary()}

  def new(declarations, identifier),
    do: %XDR.Enum{declarations: declarations, identifier: identifier}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter, it receives
  a XDR.Enum type which contains the Enum and the identifier which you need to encode

  Returns a tuple with the the XDR resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr(t()) :: {:ok, binary()}
  def encode_xdr(%XDR.Enum{declarations: declarations}) when not is_list(declarations),
    do: raise(EnumErr, :not_list)

  def encode_xdr(%XDR.Enum{identifier: identifier}) when not is_atom(identifier),
    do: raise(EnumErr, :not_an_atom)

  def encode_xdr(%XDR.Enum{declarations: declarations, identifier: identifier}) do
    binary =
      declarations[identifier]
      |> XDR.Int.new()
      |> XDR.Int.encode_xdr!()

    {:ok, binary}
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of encode a value inside of the enum structure based on the identifier received by parameter, it receives
  a XDR.Enum type which contains the Enum and the identifier which you need to encode

  Returns the XDR resulted from encode the value wich represents a key in the enum structure
  """
  @spec encode_xdr!(enum :: t()) :: binary()
  def encode_xdr!(enum), do: encode_xdr(enum) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR which represents a value inside an enum structure,it receives an XDR.Enum structure that
  contains the identifier and the enum which it belongs

  Returns a tuple with the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr(t()) :: {:ok, {atom(), binary()}}
  def decode_xdr(%XDR.Enum{identifier: identifier}) when not is_binary(identifier),
    do: raise(EnumErr, :not_binary)

  def decode_xdr(%XDR.Enum{declarations: declarations}) when not is_list(declarations),
    do: raise(EnumErr, :not_list)

  def decode_xdr(%XDR.Enum{declarations: declarations, identifier: identifier}) do
    {value, rest} =
      XDR.Int.new(identifier)
      |> XDR.Int.decode_xdr!()

    Enum.find(declarations, &Kernel.===(elem(&1, 1), value))
    |> get_response(rest)
  end

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR which represents a value inside an enum structure,it receives an XDR.Enum structure that
  contains the identifier and the enum which it belongs

  Returns the key of the decoded enum and the remaining bytes if there are.
  """
  @spec decode_xdr!(t()) :: {atom(), binary()}
  def decode_xdr!(enum), do: decode_xdr(enum) |> elem(1)

  @spec get_response({name :: atom(), any}, rest :: binary()) :: {atom(), {atom(), binary()}}
  defp get_response({name, _}, rest), do: {:ok, {name, rest}}

  @spec get_response(nil, _rest :: binary()) :: EnumErr
  defp get_response(nil, _rest), do: raise(EnumErr, :not_valid)
end
