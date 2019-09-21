%{
  configs: [
    %{
      name: "default",
      files: %{
        included: [
          "lib",
          "test",
          "mix.exs",
          "config/*.exs",
          "mix.exs",
          ".formatter.exs"
        ],
        excluded: []
      },
      checks: [
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120},
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Design.AliasUsage, priority: :low, if_nested_deeper_than: 2}
      ]
    }
  ]
}
