local snips, autosnips = {}, {}

local tex = require('utils.latex')

local pipe = function(fns)
	return function(...)
		for _, fn in ipairs(fns) do
			if not fn(...) then
				return false
			end
		end
		return true
	end
end

local appended_space_after_insert = function()
	vim.api.nvim_create_autocmd('InsertCharPre', {
		callback = function()
			if string.find(vim.v.char, '%a') then
				vim.v.char = ' ' .. vim.v.char
			end
		end,
		buffer = 0,
		once = true,
		desc = 'Auto Add a Space after Inline Math',
	})
end

-- local smart_space = function(args, _)
-- 	local space = ''
-- 	if string.find(args[1][1], '^%a') then
-- 		space = ' '
-- 	end
-- 	return sn(nil, t(space))
-- end

autosnips = {

	-- priority 60:

	s({ trig = '([hH])_(%d)(%u)', name = 'cohomology-d', regTrig = true }, {
		f(function(_, snip)
			return snip.captures[1] .. '^{' .. snip.captures[2] .. '}(' .. snip.captures[3] .. ','
		end, {}),
		i(1),
		t(')'),
		i(0),
	}, { condition = tex.in_mathzone }),
	s(
		{ trig = '(%a)p(%d)', name = 'x[n+1]', regTrig = true },
		{ f(function(_, snip)
			return snip.captures[1] .. '_{n+' .. snip.captures[2] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),

	-- priority 50:

	s({ trig = '\\varpii', name = '\\varpi_i' }, { t('\\varpi_{i}') }, { condition = tex.in_mathzone }),
	s({ trig = '\\varphii', name = '\\varphi_i' }, { t('\\varphi_{i}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '\\([xX])ii', name = '\\xi_{i}', regTrig = true },
		{ f(function(_, snip)
			return string.format('\\%si_{i}', snip.captures[1])
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '\\([pP])ii', name = '\\pi_{i}', regTrig = true },
		{ f(function(_, snip)
			return string.format('\\%si_{i}', snip.captures[1])
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '\\([pP])hii', name = '\\phi_{i}', regTrig = true },
		{ f(function(_, snip)
			return string.format('\\%shi_{i}', snip.captures[1])
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '\\([cC])hii', name = '\\chi_{i}', regTrig = true },
		{ f(function(_, snip)
			return string.format('\\%shi_{i}', snip.captures[1])
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '\\([pP])sii', name = '\\psi_{i}', regTrig = true },
		{ f(function(_, snip)
			return string.format('\\%ssi_{i}', snip.captures[1])
		end, {}) },
		{ condition = tex.in_mathzone }
	),

	-- priority 40:

	s({ trig = 'cod', name = 'codimension' }, { t('\\codim') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'dint', name = 'integral', dscr = 'Insert integral notation.' },
		{ t('\\int_{'), i(1, '-\\infty'), t('}^{'), i(2, '\\infty'), t('} ') },
		{ condition = tex.in_mathzone }
	),

	-- priority 30:

	s({ trig = 'coker', name = 'cokernel' }, { t('\\coker') }, { condition = tex.in_mathzone }),

	-- priority 20:

	s({
		trig = '(%s)([b-zB-HJ-Z0-9])([,;.%-%)]?)%s+',
		name = 'single-letter variable',
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			return snip.captures[1] .. '\\(' .. snip.captures[2] .. '\\)' .. snip.captures[3]
		end, {}),
	}, { condition = tex.in_text }),
	s({
		trig = '(%s)([0-9]+[a-zA-Z]+)([,;.%)]?)%s+',
		name = 'surround word starting with number',
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			return snip.captures[1] .. '\\(' .. snip.captures[2] .. '\\)' .. snip.captures[3]
		end, {}),
	}, { condition = tex.in_text }),
	s({ trig = '(%s)(%w[-_+=><]%w)([,;.%)]?)%s+', name = 'surround i+1', wordTrig = false, regTrig = true }, {
		f(function(_, snip)
			return snip.captures[1] .. '\\(' .. snip.captures[2] .. '\\)' .. snip.captures[3]
		end, {}),
	}, { condition = tex.in_text }),

	s({ trig = 'ses', name = 'short exact sequence' }, {
		c(1, { t('0'), t('1') }),
		t('\\longrightarrow '),
		i(2),
		t('\\longrightarrow '),
		i(3),
		t('\\longrightarrow '),
		i(4),
		t('\\longrightarrow '),
		rep(1),
		i(0),
	}, { condition = tex.in_mathzone }),

	-- s({ trig = 'arcsin', name = 'arcsin' }, { t('\\arcsin') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'arccos', name = 'arccos' }, { t('\\arccos') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'arctan', name = 'arctan' }, { t('\\arctan') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'arccot', name = 'arccot' }, { t('\\arccot') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'arccsc', name = 'arccsc' }, { t('\\arccsc') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'arcsec', name = 'arcsec' }, { t('\\arcsec') }, { condition = tex.in_mathzone }),

	s({ trig = 'int', name = 'int' }, { t('\\int') }, { condition = tex.in_mathzone }),
	s({ trig = 'sin', name = 'sin' }, { t('\\sin') }, { condition = tex.in_mathzone }),
	s({ trig = 'cos', name = 'cos' }, { t('\\cos') }, { condition = tex.in_mathzone }),
	s({ trig = 'tan', name = 'tan' }, { t('\\tan') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'cot', name = 'cot' }, { t('\\cot') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'csc', name = 'csc' }, { t('\\csc') }, { condition = tex.in_mathzone }),
	-- s({ trig = 'sec', name = 'sec' }, { t('\\sec') }, { condition = tex.in_mathzone }),

	s({ trig = 'abs', name = 'abs' }, { t('\\abs{'), i(1), t('}') }, { condition = tex.in_mathzone }),
	s({ trig = 'deg', name = 'deg' }, { t('\\deg') }, { condition = tex.in_mathzone }),
	s({ trig = 'det', name = 'det' }, { t('\\det') }, { condition = tex.in_mathzone }),
	s({ trig = 'dim', name = 'dim' }, { t('\\dim') }, { condition = tex.in_mathzone }),
	s({ trig = 'hom', name = 'hom' }, { t('\\hom') }, { condition = tex.in_mathzone }),
	s({ trig = 'inf', name = 'inf' }, { t('\\inf') }, { condition = tex.in_mathzone }),
	s({ trig = 'max', name = 'max' }, { t('\\max') }, { condition = tex.in_mathzone }),
	s({ trig = 'min', name = 'min' }, { t('\\min') }, { condition = tex.in_mathzone }),
	s({ trig = 'ker', name = 'ker' }, { t('\\ker') }, { condition = tex.in_mathzone }),
	s({ trig = 'sup', name = 'sup' }, { t('\\sup') }, { condition = tex.in_mathzone }),

	s(
		{ trig = '(%a)ii', name = 'alph i', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return snip.captures[1] .. '_{i}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '(%a)jj', name = 'alph j', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return snip.captures[1] .. '_{j}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),

	s({ trig = 'xmm', wordTrig = false, name = 'x_m' }, { t('x_{m}') }, { condition = tex.in_mathzone }),
	s({ trig = 'xnn', wordTrig = false, name = 'x_n' }, { t('x_{n}') }, { condition = tex.in_mathzone }),
	s({ trig = 'ymm', wordTrig = false, name = 'y_m' }, { t('y_{m}') }, { condition = tex.in_mathzone }),
	s({ trig = 'ynn', wordTrig = false, name = 'y_n' }, { t('y_{n}') }, { condition = tex.in_mathzone }),

	s({ trig = '([hH])([i-npq])(%u)', name = 'cohomology-a', regTrig = true }, {
		f(function(_, snip)
			return snip.captures[1] .. '^{' .. snip.captures[2] .. '}(' .. snip.captures[3] .. ','
		end, {}),
		i(1),
		t(')'),
		i(0),
	}, { condition = tex.in_mathzone }),

	s(
		{ trig = '<->', wordTrig = false, name = 'leftrightarrow <->' },
		{ t('\\leftrightarrow ') },
		{ condition = tex.in_mathzone }
	),

	-- priority 10:

	s(
		{ trig = '(%a)bar', name = 'overline', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\overline{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '(%a)hat', name = 'widehat', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\widehat{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '(%a)td', name = 'widetilde', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\widetilde{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),

	-- priority 1:

	-- phrases which are often used

	s({ trig = 'quad', name = 'quad' }, { t('\\quad ') }, { condition = tex.in_mathzone }),

	s({ trig = 'bar', name = 'overline' }, { t('\\overline{'), i(1), t('}') }, { condition = tex.in_mathzone }),
	s({ trig = 'hat', name = 'widehat' }, { t('\\widehat{'), i(1), t('}') }, { condition = tex.in_mathzone }),
	s({ trig = 'td', name = 'widetilde' }, { t('\\widetilde{'), i(1), t('}') }, {
		condition = tex.in_mathzone,
	}),

	s({ trig = 'O([A-NP-Za-z])', name = 'local ring, structure sheaf', wordTrig = false, regTrig = true }, {
		f(function(_, snip)
			return '\\mathcal{O}_{' .. snip.captures[1] .. '}'
		end, {}),
	}, { condition = tex.in_mathzone }),

	-- priority 0:

	-- s({ trig = 'mk', name = 'inline math', dscr = 'Insert inline Math Environment.' }, {
	-- 	t('\\('),
	-- 	i(1),
	-- 	t('\\)'),
	-- 	d(2, smart_space, { 3 }),
	-- 	i(3),
	-- }),
	s({ trig = 'mk', name = 'inline math', dscr = 'Insert inline Math Environment.' }, {
		t('\\('),
		i(1),
		t('\\)'),
		i(0),
	}, {
		condition = tex.in_text,
		callbacks = {
			[-1] = { [events.leave] = appended_space_after_insert },
		},
	}),
	s(
		{ trig = 'dm', name = 'dispaly math', dscr = 'Insert display Math Environment.' },
		{ t { '\\[', '\t' }, i(1), t { '', '\\]' } },
		{ condition = pipe { conds.line_begin, tex.in_text } }
	),

	s({ trig = 'cref', name = '\\cref{}' }, { t('\\cref{'), i(1), t('}') }, { condition = tex.in_text }),
	s(
		{ trig = '(%w)//', name = 'fraction with a single numerator', regTrig = true },
		{ t('\\frac{'), f(function(_, snip)
			return snip.captures[1]
		end, {}), t('}{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '//', name = 'fraction' },
		{ t('\\frac{'), i(1), t('}{'), i(2), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '==', name = 'align equls', wordTrig = false },
		{ t { '&= ' }, i(1), t { ' \\\\', '' } },
		{ condition = tex.in_align }
	),

	s(
		{ trig = 'rij', name = '(x_n) n ∈ N' },
		{ t('('), i(1, 'x'), t('_'), i(2, 'n'), t(')_{'), rep(2), t('\\in '), i(3, '\\mathbb{N}'), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'rg', name = 'i = 1, ..., n' },
		{ i(1, 'i'), t(' = '), i(2, '1'), t(' \\dots, '), i(0, 'n') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'ls', name = 'a_1, ..., a_n' },
		{ i(1, 'a'), t('_{'), i(2, '1'), t('}, \\dots, '), rep(1), t('_{'), i(3, 'n'), t('}') },
		{ condition = tex.in_mathzone }
	),

	-- All arrows shortcuts
	s(
		{ trig = 'rmap', name = 'rational map arrow' },
		{ t { '\\ar@{-->}[' }, i(1), t { ']' } },
		{ condition = tex.in_xymatrix }
	),
	s(
		{ trig = 'emb', name = 'embeddeing map arrow' },
		{ t { '\\ar@{^{(}->}[' }, i(1), t { ']' } },
		{ condition = tex.in_xymatrix }
	),
	s(
		{ trig = 'rmap', wordTrig = false, name = 'dashrightarrow' },
		{ t('\\dashrightarrow ') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'emb', wordTrig = false, name = 'embedding' },
		{ t('\\hookrightarrow ') },
		{ condition = tex.in_mathzone }
	),

	s(
		{ trig = '->', wordTrig = false, name = 'rightarrow -->' },
		{ t('\\longrightarrow ') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = '!>', wordTrig = false, name = 'mapsto' }, { t('\\mapsto ') }, { condition = tex.in_mathzone }),
	s({ trig = '=>', name = 'implies', wordTrig = false }, { t('\\implies ') }, { condition = tex.in_mathzone }),
	s({ trig = '=<', name = 'impliedby', wordTrig = false }, { t('\\impliedby ') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'iff', name = 'if and only if <=>', wordTrig = false },
		{ t('\\iff ') },
		{ condition = tex.in_mathzone }
	),

	s(
		{ trig = 'tt', wordTrig = false, name = 'text' },
		{ t('\\text{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'tss', wordTrig = false, name = 'text subscript' },
		{ t('_{\\mathrm{'), i(1), t('}}') },
		{ condition = tex.in_mathzone }
	),

	-- math symbols
	s({
		trig = '([%a])(%d)',
		name = 'auto subscript 1',
		dscr = 'Subscript with a single number.',
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			return string.format('%s_%s', snip.captures[1], snip.captures[2])
		end, {}),
	}, { condition = tex.in_mathzone }),
	s({ trig = '(%a)_(%d%d)', name = 'auto subscript 2', dscr = 'Subscript with two numbers.', regTrig = true }, {
		f(function(_, snip)
			return string.format('%s_{%s}', snip.captures[1], snip.captures[2])
		end, {}),
	}, { condition = tex.in_mathzone }),

	s({ trig = 'inn', name = 'belongs to ∈', wordTrig = false }, { t('\\in ') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '!in', name = 'does not belong to ∉', wordTrig = false },
		{ t('\\notin ') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = '!=', name = 'not equal ≠', wordTrig = false }, { t('\\neq ') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '<=', name = 'less than or equal to ≤', wordTrig = false },
		{ t('\\leq ') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '>=', name = 'greater than or equal to ≥', wordTrig = false },
		{ t('\\geq ') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = '<<', name = 'much less than ≪', wordTrig = false }, { t('\\ll ') }, {
		condition = tex.in_mathzone,
	}),
	s(
		{ trig = '>>', name = 'much greater than ≫', wordTrig = false },
		{ t('\\gg ') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = '~~', name = 'similar ~', wordTrig = false }, { t('\\sim ') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '~=', name = 'is isomorphic to ≃', wordTrig = false },
		{ t('\\simeq ') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = 'nvs', name = 'inverse', wordTrig = false }, { t('^{-1}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '^-', name = 'negative exponents', wordTrig = false },
		{ t('^{-'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = 'sq', name = 'square root' }, { t('\\sqrt{'), i(1), t('}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = '__', name = 'subscript', wordTrig = false },
		{ t('_{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '^^', name = 'supscript', wordTrig = false },
		{ t('^{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = '**', name = 'upper star *', wordTrig = false }, { t('^{*}') }, { condition = tex.in_mathzone }),
	s({ trig = '...', name = 'dots ...', wordTrig = false }, { t('\\dots') }, { condition = tex.in_mathzone }),
	s({ trig = '||', name = 'mid |', wordTrig = false }, { t('\\mid ') }, { condition = tex.in_mathzone }),
	s({ trig = '::', name = 'colon :', wordTrig = false }, { t('\\colon ') }, { condition = tex.in_mathzone }),
	s({ trig = ':=', name = 'coloneqq :=', wordTrig = false }, { t('\\coloneqq ') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'rup', name = 'round up', wordTrig = false },
		{ t('\\rup{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'rwn', name = 'round down', wordTrig = false },
		{ t('\\rdown{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),

	s({ trig = 'lll', wordTrig = false, name = 'ell ℓ' }, { t('\\ell') }, { condition = tex.in_mathzone }),
	s({ trig = 'xx', wordTrig = false, name = 'times ×' }, { t('\\times') }, { condition = tex.in_mathzone }),
	s({ trig = 'nabl', wordTrig = false, name = 'nabla ∇' }, { t('\\nabla') }, { condition = tex.in_mathzone }),
	s({ trig = 'AA', wordTrig = false, name = 'affine 𝔸' }, { t('\\mathbb{A}') }, { condition = tex.in_mathzone }),
	s({ trig = 'CC', wordTrig = false, name = 'complex ℂ' }, { t('\\mathbb{C}') }, { condition = tex.in_mathzone }),
	s({ trig = 'DD', wordTrig = false, name = 'disc 𝔻' }, { t('\\mathbb{D}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'FF', wordTrig = false, name = 'Hirzebruch 𝔽' },
		{ t('\\mathbb{F}') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = 'HH', wordTrig = false, name = 'half plane ℍ' },
		{ t('\\mathbb{H}') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = 'NN', wordTrig = false, name = 'natural ℕ' }, { t('\\mathbb{N}') }, { condition = tex.in_mathzone }),
	s({ trig = 'OO', wordTrig = false, name = 'mathcal{O}' }, { t('\\mathcal{O}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'PP', wordTrig = false, name = 'projective ℙ' },
		{ t('\\mathbb{P}') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = 'QQ', wordTrig = false, name = 'rational ℚ' }, { t('\\mathbb{Q}') }, {
		condition = tex.in_mathzone,
	}),
	s({ trig = 'RR', wordTrig = false, name = 'real ℝ' }, { t('\\mathbb{R}') }, { condition = tex.in_mathzone }),
	s({ trig = 'ZZ', wordTrig = false, name = 'integer ℤ' }, { t('\\mathbb{Z}') }, { condition = tex.in_mathzone }),
	s(
		{ trig = 'srt', wordTrig = false, name = 'square root' },
		{ t('\\sqrt{'), i(1), t('}') },
		{ condition = tex.in_mathzone }
	),
	s({ trig = 'set', name = 'set' }, { t('\\{'), i(1), t('\\}') }, { condition = tex.in_mathzone }),
	s({ trig = 'o+', wordTrig = false, name = 'oplus' }, { t('\\oplus') }, { condition = tex.in_mathzone }),
	s({ trig = 'ox', wordTrig = false, name = 'otimes' }, { t('\\otimes') }, { condition = tex.in_mathzone }),
	s({ trig = 'cap', wordTrig = false, name = 'cap' }, { t('\\cap ') }, { condition = tex.in_mathzone }),
	s({ trig = 'cup', wordTrig = false, name = 'cup' }, { t('\\cup ') }, { condition = tex.in_mathzone }),
	s({ trig = 'nnn', wordTrig = false, name = 'bigcup' }, { t('\\bigcup') }, { condition = tex.in_mathzone }),
	s({ trig = 'uuu', wordTrig = false, name = 'bigcap' }, { t('\\bigcap') }, { condition = tex.in_mathzone }),

	-- notations which are often used in math
	s(
		{ trig = 'MK', name = 'Mori-Kleiman cone' },
		{ t('\\overline{NE}('), i(1), t(')') },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '([QRZ])P', name = 'positive', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\mathbb{' .. snip.captures[1] .. '}^{>0}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '([QRZ])N', name = 'negative', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\mathbb{' .. snip.captures[1] .. '}^{<0}'
		end, {}) },
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = '([qr])le', name = 'linearly equivalent', wordTrig = false, regTrig = true },
		{ f(function(_, snip)
			return '\\sim_{\\mathbb{' .. string.upper(snip.captures[1]) .. '}} '
		end, {}) },
		{ condition = tex.in_mathzone }
	),
}

snips = {
	-- priority 1:
	s(
		{ trig = 'c(%u)', name = 'mathcal', wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return '\\mathcal{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),
	s(
		{ trig = 'f(%a)', name = 'mathfrak', wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return '\\mathfrak{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),
	s(
		{ trig = 's(%u)', name = 'mathscr', wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return '\\mathscr{' .. snip.captures[1] .. '}'
		end, {}) },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),

	-- priority 0:

	-- General text styling like bold and so on
	s(
		{ trig = 'bf', name = 'bold', dscr = 'Insert bold text.' },
		{ t('\\textbf{'), i(1), t('}') },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = 'it', name = 'italic', dscr = 'Insert italic text.' },
		{ t('\\textit{'), i(1), t('}') },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = 'em', name = 'emphasize', dscr = 'Insert emphasize text.' },
		{ t('\\emph{'), i(1), t('}') },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = 'ni', name = 'non-indented paragraph', dscr = 'Insert non-indented paragraph.' },
		{ t { '\\noindent', '' } },
		{ condition = pipe { conds.line_begin, tex.in_text }, show_condition = tex.in_text }
	),
	s(
		{ trig = 'cite', name = 'cross refrence' },
		{ t('\\cite['), i(1), t(']{'), i(2), t('}') },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = 'cf', name = 'confer/conferatur' },
		{ t('cf.~') },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),

	s(
		{ trig = '/', name = 'fraction', dscr = 'Insert a fraction notation.', wordTrig = false },
		{ t('\\frac{'), i(1), t('}{'), i(2), t('}') },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),

	s(
		{ trig = 'sum', name = 'sum', dscr = 'Insert a sum notation.' },
		{ t('\\sum_{'), i(1), t('}^{'), i(2), t('}'), i(3) },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),
	s(
		{ trig = 'lim', name = 'limit', dscr = 'Insert a limit notation.' },
		{ t('\\lim_{'), i(1, 'n'), t('\\to '), i(2, '\\infty'), t('} ') },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),
	s(
		{ trig = 'limsup', name = 'limsup', dscr = 'Insert a limit superior notation.' },
		{ t('\\limsup_{'), i(1, 'n'), t('\\to '), i(2, '\\infty'), t('} ') },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),
	s(
		{ trig = 'prod', name = 'product', dscr = 'Insert a product notation.' },
		{ t('\\prod_{'), i(1, 'n'), t('='), i(2, '1'), t('}^{'), i(3, '\\infty'), t('}'), i(4), t(' ') },
		{ condition = tex.in_mathzone, show_condition = tex.in_mathzone }
	),

	s(
		{ trig = 'pha', name = 'sum', dscr = 'Insert a sum notation.' },
		{ t('&\\phantom{\\;=\\;} ') },
		{ condition = pipe { conds.line_begin, tex.in_mathzone }, show_condition = tex.in_mathzone }
	),
}

return snips, autosnips