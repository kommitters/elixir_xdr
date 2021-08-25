defmodule XDR.QuadFloat do
  @moduledoc """
  This module is not supported by the actual byte size
  """

  @behaviour XDR.Declaration

  @doc """
  not supported
  """
  @impl true
  def encode_xdr(_), do: {:error, :not_supported}

  @doc """
  not supported
  """
  @impl true
  def encode_xdr!(_), do: raise("Not supported function")

  @doc """
  not supported
  """
  @impl true
  def decode_xdr(_, _), do: {:error, :not_supported}

  @doc """
  not supported
  """
  @impl true
  def decode_xdr!(_, _), do: raise("Not supported function")
end
