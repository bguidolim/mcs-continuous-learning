## MANDATORY — Code Editing with Serena's Symbolic Tools

**NEVER** use Read, Edit, Grep, or Glob for Swift files. Always use Serena equivalents:
- **Navigation**: Use `search_for_pattern`, `find_symbol`, `find_referencing_symbols`, and `get_symbols_overview` instead of Grep/Glob for locating code.
- **Editing**: Use `replace_symbol_body`, `insert_after_symbol`, `insert_before_symbol`, and `rename_symbol` instead of Edit for modifying code.
- **Context**: Use `get_symbols_overview` to understand file structure before making changes.
- **Before removing or renaming** any symbol, verify it is unused via `find_referencing_symbols`.