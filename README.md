# XDR kommit

**Process XDR types based on the [rfc4506](https://www.ietf.org/rfc/rfc4506.txt)**

Documentation: [TO-DO](https://github.com/kommitters/xdr/tree/develop)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `xdr_kommit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xdr_kommit, "~> 0.1.0"}
  ]
end
```

## Implemented types

You can find the following types completely implemented in XDR kommit:

```elixir
XDR.Int                  #Section 4.1, RFC4506
XDR.UInt                 #Section 4.2, RFC4506
XDR.Enum                 #Section 4.3, RFC4506
XDR.Bool                 #Section 4.4, RFC4506
XDR.HyperInt             #Section 4.5, RFC4506
XDR.HyperUInt            #Section 4.5, RFC4506
XDR.Float                #Section 4.6, RFC4506
XDR.DoubleFloat          #Section 4.7, RFC4506
XDR.FixedOpaque          #Section 4.9, RFC4506
XDR.VariableOpaque       #Section 4.10, RFC4506
XDR.String               #Section 4.11, RFC4506
XDR.FixedArray           #Section 4.12, RFC4506
XDR.VariableArray        #Section 4.13, RFC4506  
XDR.Struct               #Section 4.14, RFC4506
XDR.Union                #Section 4.15, RFC4506
XDR.Void                 #Section 4.16, RFC4506
XDR.Optional             #Section 4.19, RFC4506
```

**The following types were not implemented:**
XDR.QuadFloat, Section 4.8, RFC4506, not supported 128 byte size

XDR.Const, Section 4.17, RFC4506, you can use elixir constants

XDR.Typedef, Section 4.18, RFC4506, better to implement it with elixir modules, you can see some examples below

## Behaviour is the key

All the XDR implementations are implemented under the parameters of behavior, this behavior declares 4 types which must have all the XDR implementations, there is the behavior:

```elixir
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
  @callback decode_xdr(binary, term) :: {:ok, {term, binary}} | Error.t()

  # decode XDR for any type returns the resulted converted value
  @callback decode_xdr!(binary, term) :: {term, binary} | Error.t()
end
```
All the XDR types implemented on this project satisfy this @behaviour

## How to implement basic XDR types?
Each module of the XDR accomplishes with an XDR.Declaration behaviour, for the above all the types have implemented functions like encode_xdr and decode_xdr, the basic XDR types can be used as they are

### Basic types
```elixir
XDR.Int
XDR.Uint
XDR.Bool
XDR.HyperInt
XDR.HyperUint
XDR.Float
XDR.DoubleFloat
XDR.QuadrupleFloat  # not implemented
XDR.Void
```

### Integer example
If you need to create a new integer type you can use the new/1 function which receives the integer value and creates an XDR.Int structure as this:
```elixir
XDR.Int.new(1234) #returns the following structure %XDR.Int{datum: 1234}
```

To encode an Integer value you'll need to call the encode_xdr/1 function, it receives an structure of the current type, XDR.Int in this case
```elixir
XDR.Int.encode_xdr(%XDR.Int{datum: 1234}) #returns the following tuple {:ok, <<0, 0, 4, 210>>} the binary resulted from encode the integer is the XDR value
```

To decode an Integer value you'll need to call the decode_xdr/2 function, it receives a bunch of bytes and a structure which represents the XDR type, the basic types don't need this structure, look at the following example
```elixir
# The function decode_xdr implemented on the basic types could receive a single one parameter as shown in the following example:
XDR.Int.decode_xdr(<<0, 0, 4, 210>>)
# This call will return a tuple with the decoded value as this:
{:ok, {%XDR.Int{datum: 1234}, ""}}
```

If you don't like or need the tuples, you can use the encode_xdr!/1 and decode_xdr!/2 functions to get only the decoded value
```elixir
# The function decode_xdr implemented on the basic types could receive a single one parameter as shown in the following example:
XDR.Int.decode_xdr!(<<0, 0, 4, 210>>)
# This call will return a tuple with the decoded value as this:
{%XDR.Int{datum: 1234}, ""}
```

If you pay attention to the return you can see that is a tuple, that is because when we have a bunch of bytes that exceeds the byte size of the type (4 in this case) the second item will contain the rest of the binary, see the following example to solve your doubts.
```elixir
# The function decode_xdr implemented on the basic types could receive a single one parameter as shown in the following example:
XDR.Int.decode_xdr!(<<0, 0, 4, 210, 0, 0, 0, 0>>)
# This call will return a tuple with the decoded value as this:
{%XDR.Int{datum: 1234}, <<0, 0, 0, 0>>}
```
The rest binaries will be very helpful when we start to use more complex types!

## How to implement compound XDR types?
The following modules also are XDR implementations, so, remember the XDR.Declaration behaviour and let's start:

### Compound types
XDR.Type.Enum
XDR.Type.FixedOpaque
XDR.Type.VariableOpaque
XDR.Type.String
XDR.Type.FixedArray
XDR.Type.VariableArray
XDR.Type.Struct
XDR.Type.Union
XDR.Type.Optional

## Implements an Enum type
This type is a simple type that consists of two very important things, the declarations, and the identifier, the declarations represent the possible values of the enum representation and the identifier represents the value to select in the declaration:

### What I'm talking about?
Let's see the implementation for an example enum type
```elixir
defmodule XDR.Bool do
  @behaviour XDR.Declaration

  alias XDR.Enum
  alias XDR.Error.Bool

  @boolean [false: 0, true: 1]

  defstruct declarations: @boolean, identifier: nil

  @type t :: %XDR.Bool{declarations: keyword(), identifier: boolean()}

  @spec new(atom()) :: t()
  def new(identifier), do: %XDR.Bool{declarations: @boolean, identifier: identifier}

  @impl XDR.Declaration
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.Bool{identifier: identifier}) when not is_boolean(identifier),
    do: raise(Bool, :not_boolean)

  def encode_xdr(%XDR.Bool{} = boolean), do: Enum.encode_xdr(boolean)

  @impl XDR.Declaration
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(boolean), do: encode_xdr(boolean) |> elem(1)

  @impl XDR.Declaration
  @spec decode_xdr(bytes :: binary, struct :: t | any) :: {:ok, {t, binary}}
  def decode_xdr(bytes, struct \\ %XDR.Bool{declarations: @boolean})
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: raise(Bool, :invalid_value)
  def decode_xdr(bytes, struct) do
    {enum, rest} = Enum.decode_xdr!(bytes, struct)

    decoded_bool = new(enum.identifier)

    {:ok, {decoded_bool, rest}}
  end

  @impl XDR.Declaration
  @spec decode_xdr!(bytes :: binary, struct :: t | any) :: {t(), binary}
  def decode_xdr!(bytes, struct \\ %XDR.Bool{declarations: @boolean})
  def decode_xdr!(bytes, struct), do: decode_xdr(bytes, struct) |> elem(1)
end
```

The XDR.Bool module is the perfect example to show an Enum implementation, as you see first we create a keyword which will be used as declarations, the declarations in an Enum type are always statically defined because in a boolean or an enum type you must have these declarations to use them.

In this case, we must create a type of XDR.Bool to encode it and decode it with the help of the new / 1 function, once we have the boolean defined we can encode it for this we can use the XDR.Enum functions but remember! we must always satisfy behavior.

As you can see all the functions of the XDR.Bool module use the Enum functions to work

Now we can continue with the decoding, something very important that we must take into account when decoding any structure is to send the correct parameters, the decode_xdr / 2 function always receives the set of binaries as the first parameter and a structure containing the information necessary to decode those binaries in the correct structure, that is very important because you can add this structure on the code and you won't worry about it in the future, in this case, that structure represents a boolean which contains the declarations, these will be used to return the declaration to which the binaries belong.

### How can I use it?

```elixir
# To encode a Boolean type first create the Bool type or sent an XDR.Bool struct
XDR.Bool.new(true)
|> XDR.Bool.encode_xdr() # It returns an encoded true {:ok, <<0, 0, 0, 1>>}

# To decode this binary you can use the following:
XDR.Bool.decode_xdr(<0, 0, 0, 1>>) 
# this call returns the XDR.Bool structure with the result: {:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```

## Implements a FixedOpaque type 

This type is very simple, let's think of a string that must always match the same length regardless of whether it receives fewer characters than necessary. In these cases we can use a FixedOpaque, for example:

```elixir
defmodule StaticLength do
  @behaviour XDR.Declaration

  @length 12 # We can define the static length for this implementation

  defstruct value: nil, length: nil

  @type t :: %StaticLength{value: binary, length: integer}

  def new(bytes) do #The received string must be a binary
    %StaticLength{value: bytes, length: @length}
  end

  defdelegate encode_xdr(static_length), to: XDR.FixedOpaque # This is other way to implement the required functions

  def decode_xdr(bytes, struct \\ %{length: @length}) #You can define your own functions and return what do you need
  def decode_xdr(bytes, struct) do
    {fixed_opaque, _rest} = XDR.FixedOpaque.decode_xdr!(bytes, struct)

    decoded_static_length = fixed_opaque.opaque |> new()

    {:ok, decoded_static_length}
  end
end
```

## Implements a Struct type
A Struct type can be coded in many ways, this is one of them

```elixir
defmodule Struct_impl do
  @behaviour XDR.Declaration

  defstruct file_name: XDR.String, file_size: XDR.Int

  @type t :: %Struct_impl{file_name: XDR.String.t(), file_size: XDR.Int.t()}

  def new(file_name, file_size) do
    %Struct_impl{file_name: file_name, file_size: file_size}
  end

  @impl XDR.Declaration
  def encode_xdr(struct_file) do
    component_keyword = struct_file |> Map.from_struct() |> Map.to_list()

    XDR.Struct.new(component_keyword)
    |> XDR.Struct.encode_xdr()
  end

  @impl XDR.Declaration
  def encode_xdr!(struct_file), do: encode_xdr(struct_file) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) do
    component_keyword = Struct_impl.__struct__() |> Map.from_struct() |> Map.to_list()

    XDR.Struct.decode_xdr!(bytes, %{components: component_keyword})
    |> perform_struct()
  end

  @impl XDR.Declaration
  def decode_xdr!(bytes, struct), do: decode_xdr(bytes, struct) |> elem(1)

  defp perform_struct({components, rest}) do
    struct_components = components.components
    struct = Struct_impl.new(struct_components[:file_name], struct_components[:file_size])

    {:ok, {struct, rest}}
  end
end
```

## Implements a Union type
The Union type is more complex because it uses an already defined Enum, Int or Uint structure to use it, If we need to use it with an Enum we need the defined module as XDR.Boolean, In this case, we will implement an XDR.Enum module called SCPStatementType

```elixir
defmodule SCPStatementType do
  @behaviour XDR.Declaration

  defstruct declarations: nil, identifier: nil

  @scp_statement_type [
    SCP_ST_PREPARE: 0,
    SCP_ST_CONFIRM: 1,
    SCP_ST_EXTERNALIZE: 2,
    SCP_ST_NOMINATE: 3
  ]

  def new(identifier),
    do: %SCPStatementType{declarations: @scp_statement_type, identifier: identifier}

  @impl XDR.Declaration
  defdelegate encode_xdr(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate encode_xdr!(enum), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr(bytes, struct), to: XDR.Enum
  @impl XDR.Declaration
  defdelegate decode_xdr!(bytes, struct), to: XDR.Enum
end
```

After that we can create our new Union implementation:

```elixir
defmodule UnionSCPStatementType do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.Enum, arms: nil, struct: nil

  @arms [
    SCP_ST_PREPARE: XDR.Int.new(60),
    SCP_ST_CONFIRM: XDR.String.new("Confirm"),
    SCP_ST_EXTERNALIZE: XDR.Bool.new(false),
    SCP_ST_NOMINATE: XDR.Float.new(3.46)
  ]

  def new(identifier),
    do: %UnionSCPStatementType{
      discriminant: SCPStatementType.new(identifier),
      arms: @arms,
      struct: %{discriminant: XDR.Enum}
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionSCPStatementType{} = union), do: XDR.Union.encode_xdr(union)

  @impl XDR.Declaration
  def encode_xdr!(%UnionSCPStatementType{} = union), do: encode_xdr(union) |> elem(1)

  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionSCPStatementType{} = union), do: XDR.Union.decode_xdr(bytes, union)

  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, %UnionSCPStatementType{} = union), do: XDR.Union.decode_xdr!(bytes, union)
end
```
That's all! Now we can use it as union!

### Using UnionSCPStatementType module
```elixir
  UnionSCPStatementType.new(:SCP_ST_PREPARE) # We create a Union structure with the identifier which we need
  # It returns a Union structure like this -> 
  # %UnionSCPStatementType{
  #   arms: [
  #     SCP_ST_PREPARE: %XDR.Int{datum: 60},
  #     SCP_ST_CONFIRM: %XDR.String{max_length: 4294967295, string: "Confirm"},
  #     SCP_ST_EXTERNALIZE: %XDR.Bool{
  #       declarations: [false: 0, true: 1],
  #       identifier: false
  #     },
  #     SCP_ST_NOMINATE: %XDR.Float{float: 3.46}
  #   ],
  #   discriminant: %SCPStatementType{
  #     declarations: [
  #       SCP_ST_PREPARE: 0,
  #       SCP_ST_CONFIRM: 1,
  #       SCP_ST_EXTERNALIZE: 2,
  #       SCP_ST_NOMINATE: 3
  #     ],
  #     identifier: :SCP_ST_PREPARE
  #   },
  #   struct: %{discriminant: XDR.Enum}
  # }
  |> UnionSCPStatementType.encode_xdr()
```
And the result will be {:ok, <<0, 0, 0, 0, 0, 0, 0, 60>>}

```elixir
UnionSCPStatementType.decode_xdr(<<0, 0, 0, 0, 0, 0, 0, 60>>)
```
It will return {:ok, {{:SCP_ST_PREPARE, %XDR.Int{datum: 60}}, ""}}

### Using UnionInt or UnionUint module

But remember the Union type can receive Integer types, for this we need to create another module to manage this case

```elixir
defmodule UnionNumber do
  @behaviour XDR.Declaration

  defstruct discriminant: XDR.UInt, arms: nil, struct: nil

  @arms %{
    0 => XDR.Int.new(60),
    1 => XDR.String.new("Confirm"),
    2 => XDR.Bool.new(false),
    3 => XDR.Float.new(3.46)
  }

  def new(identifier),
    do: %UnionNumber{
      discriminant: XDR.UInt.new(identifier),
      arms: @arms,
      struct: %{discriminant: XDR.UInt}
    }

  @impl XDR.Declaration
  def encode_xdr(%UnionNumber{} = union), do: XDR.Union.encode_xdr(union)
  @impl XDR.Declaration
  def encode_xdr!(%UnionNumber{} = union), do: XDR.Union.encode_xdr!(union)
  @impl XDR.Declaration
  def decode_xdr(bytes, union \\ new(nil))
  def decode_xdr(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr(bytes, union)
  @impl XDR.Declaration
  def decode_xdr!(bytes, union \\ new(nil))
  def decode_xdr!(bytes, %UnionNumber{} = union), do: XDR.Union.decode_xdr!(bytes, union)
end
```

**Using the code**

```elixir
  UnionNumber.new(3) # We create a Union structure with the identifier which we need
  # It returns a Union structure like this -> 
  # %UnionNumber{
  #   arms: %{
  #     0 => %XDR.Int{datum: 60},
  #     1 => %XDR.String{max_length: 4294967295, string: "Confirm"},
  #     2 => %XDR.Bool{declarations: [false: 0, true: 1], identifier: false},
  #     3 => %XDR.Float{float: 3.46}
  #   },
  #   discriminant: %XDR.UInt{datum: 3},
  #   struct: %{discriminant: XDR.UInt}
  # }
  |> UnionNumber.encode_xdr()
```
And the result will be {:ok, <<0, 0, 0, 3, 64, 93, 112, 164>>}

```elixir
UnionNumber.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)
```
It will return {:ok, {{3, %XDR.Float{float: 3.4600000381469727}}, ""}}

## Implements a Optional type
We will use an Optional String, but you can use any other XDR implementation, your types also.

```elixir
defmodule OptionalString do
  @behaviour XDR.Declaration

  defstruct type: nil

  def new(type), do: %OptionalString{type: type}

  defdelegate encode_xdr(type), to: XDR.Optional
  defdelegate encode_xdr!(type), to: XDR.Optional

  def decode_xdr(bytes, struct \\ %{type: XDR.String})
  def decode_xdr(bytes, struct), do: XDR.Optional.decode_xdr(bytes, struct)

  def decode_xdr!(bytes, struct \\ %{type: XDR.String})
  def decode_xdr!(bytes, struct), do: XDR.Optional.decode_xdr!(bytes, struct)
end
```

You can use it in the following way

```
iex(1)> OptionalString.new(XDR.String.new("Hello")) |> OptionalString.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 5, 72, 101, 108, 108, 111, 0, 0, 0>>}

iex(2)> OptionalString.new(nil) |> OptionalString.encode_xdr()                    
{:ok, <<0, 0, 0, 0>>}
```