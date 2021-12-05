-- copied/adapted from
--
local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local isn = ls.indent_snippet_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

ls.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "choiceNode", "Comment" } },
            },
        },
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true,
})


ls.snippets = {
  python = {
    s("parser", {
      t({"parser = argparse.ArgumentParser()", "parser.add_argument("}),
      i(1),
      t({")", "args = parser.parse_args()"})
    }),
    s("ifmain", {
      t({"def main() -> None:", "\t"}),
      i(1, "pass"),
      t({"", "", "", "if __name__ == '__main__':", "\tmain()"})
    }),
    s("tryexcept", {
      t({"try:", "\t"}),
      i(2, "pass"),
      t({"", "except"}),
      c(1, {
        t(" KeyError"),
        t(" ValueError"),
        t(" TypeError"),
        t(""),
       }),
      t({":", "\t"}),
      i(3, "pass")
     }),
    s("def __init__", {
      t("def __init__(self, "), i(1), t({"):", "\t"}),
      i(2, "pass"),
      }),
    s("def", {
      t("def "), i(1), t("(self"), i(2), t(") -> "), i(3), t({":", "\t"}),
      i(4, "pass"),
      })
  },
  cpp = {
    s("cout", {
      t("std::cout << "),
      i(1),
      t(" << std::endl;")
    }),
    s("for range", {
      t("for (auto &"),
      i(1),
      t(" : "),
      i(2),
      t({") {", "\t"}),
      i(3),
      t({"","}", ""})
    }),
  }
}
