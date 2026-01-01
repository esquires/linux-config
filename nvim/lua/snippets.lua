-- see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
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
local rep = require("luasnip.extras").rep
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

local function get_header_guard_str()
  local get_git_dir = function()
    local dir_name = vim.fn.expand('%:p:h')
    local git_root, ret = require("telescope.utils").get_os_command_output(
      {"git", "rev-parse", "--show-toplevel" }, dir_name
    )
    return git_root[1]
  end

  local fname = vim.fn.expand("%:p:r")
  local success, git_root = pcall(get_git_dir)

  local rel_fname

  if success == false or git_root == nil then
    rel_fname = vim.fn.expand("%:t:r")
  else
    rel_fname = string.sub(fname, string.len(git_root) + 2, string.len(fname))
  end

  rel_fname = string.upper(string.gsub(rel_fname, "/", "_"))
  rel_fname = string.upper(string.gsub(rel_fname, "-", "_"))
  rel_fname = rel_fname .. "_H_"
  return rel_fname

end

ls.add_snippets(nil, {
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
      }),
    s("ic", {
      t("from icecream import ic; ic("), i(1), t(")")
    }),
  },
  cpp = {
    s("cout", {
      t("std::cout << "),
      i(1),
      t(" << std::endl;")
    }),
    s("ifndef", {
      t("#ifndef "),
      f(get_header_guard_str, {}),
      t({"", "#define "}),
      f(get_header_guard_str, {}),
      t({"", ""}),
      t({"", ""}),
      i(1),
      t({"", ""}),
      t({"", ""}),
      t("#endif // "),
      f(get_header_guard_str, {}),
    }),
    s("namespace", {
      t("namespace "),
      i(1),
      t({" {", "\t"}),
      t({"", ""}),
      i(2),
      t({"", ""}),
      t({"", "}  // "}),
      rep(1),
    }),
    s("class", {
      t("class "),
      i(1),
      t({" {", " public:", "\t"}),
      i(2),
      t({"", "};"}),
    }),
    s("struct", {
      t("struct "),
      i(1),
      t({" {", "\t"}),
      i(2),
      t({"", "};"}),
    }),
    s("int_main", {
      t({"int main(int argc, char *argv[]) {", "\t"}),
      i(1),
      t({"", "\treturn 0;", "}"}),
    }),
    s("for", {
      t("for (std::size_t i = 0; i < "),
      i(1),
      t({".size(); i++) {", "\t"}),
      i(2),
      t({"","}"})
    }),
    s("forRange", {
      t("for (auto &"),
      i(1),
      t(" : "),
      i(2),
      t({") {", "\t"}),
      i(3),
      t({"","}", ""})
    }),
    s("lambda", {
      t('auto '),
      i(1),
      t(' = [&]('),
      i(2, "auto& "),
      i(3),
      t("){return "),
      i(4),
      t(";};")
    }),
    s("if", {
      t("if ("),
      i(1),
      t({") {", "\t"}),
      i(2),
      t({"", "}"})
    })
  },
  lua = {
    s("forloop", {
      t("for "),
      i(1, "_"),
      t(", "),
      i(2, "_"),
      t(" in pairs("),
      i(3),
      t({") do", "\t"}),
      i(4),
      t({"", "end"})
    }),
    s("if", {
      t("if "),
      i(1),
      t({" then", "\t"}),
      i(2),
      t({"", "end"})
    }),
  },
  norg = {
    s("task", {
      t("#project "), i(1),
      t({"", "#waiting.for "}), i(2),
      t({"", "#time.start "}), i(3),
      t({"", "#time.due "}), i(4),
      t({"", "#contexts "}), i(5),
      t({"", "- [ ] "})
    }),
  }
})
