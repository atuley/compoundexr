defmodule Compoundexr.Compound.Result do
  import Money.Sigils

  defstruct final_balance: ~M[0], final_contribution: ~M[0], years: [], return_after_taxes: 0.0
end
