local line_matches = require("todoage")._test.line_matches

describe("line_matches", function()
	describe("with default keywords (TODO, FIXME, HACK)", function()
		it("matches a bare keyword", function()
			assert.is_truthy(line_matches("// TODO"))
		end)

		it("matches a keyword followed by a colon", function()
			assert.is_truthy(line_matches("// TODO: refactor this"))
		end)

		it("matches a keyword followed by parentheses", function()
			assert.is_truthy(line_matches("// TODO(alice): write tests"))
		end)

		it("matches each of the default keywords", function()
			assert.is_truthy(line_matches("// FIXME"))
			assert.is_truthy(line_matches("// HACK"))
		end)

		it("does not match a keyword embedded in an identifier", function()
			assert.is_falsy(line_matches("const myTODOList = []"))
			assert.is_falsy(line_matches("function processTODO() {}"))
		end)

		it("does not match a keyword used as part of a longer identifier", function()
			assert.is_falsy(line_matches("const TODO_KEY = 1"))
			assert.is_falsy(line_matches("const FIXMEZ = true"))
		end)

		it("does not match a line without any keyword", function()
			assert.is_falsy(line_matches("const x = 42"))
			assert.is_falsy(line_matches(""))
			assert.is_falsy(line_matches("// just a comment"))
		end)

		it("does not match keywords as a case-insensitive variant", function()
			assert.is_falsy(line_matches("// todo: lowercase"))
			assert.is_falsy(line_matches("// Todo: mixed case"))
		end)
	end)
end)
