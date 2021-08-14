defmodule Subscriber do
  defstruct name: nil, number: nil, cpf: nil

  def register(name, number, cpf) do
    %__MODULE__{name: name, number: number, cpf: cpf}
  end
end
