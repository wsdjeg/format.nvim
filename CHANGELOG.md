# Changelog

## [1.3.0](https://github.com/wsdjeg/format.nvim/compare/v1.2.0...v1.3.0) (2025-10-20)


### Features

* add asmfmt for asm ([e3fcf10](https://github.com/wsdjeg/format.nvim/commit/e3fcf103a0b167f365c12ae22f14470d241ce69a))
* add astyle for java ([6f7ee57](https://github.com/wsdjeg/format.nvim/commit/6f7ee5729385177c6b87a5130e8e78c836ed91f0))
* add js-beautify formatter for javascript ([f6b65b7](https://github.com/wsdjeg/format.nvim/commit/f6b65b7ccf3b460bf3c7edbbd222177f251d96a6))
* add mixformat for elixir ([f5b4963](https://github.com/wsdjeg/format.nvim/commit/f5b49634754af977a755365000f03eba98980b09))
* add stylua formatter ([d72462a](https://github.com/wsdjeg/format.nvim/commit/d72462a96d96f5693b4313f77625a4c575fe4b68))
* support default indent ([ad2a3c1](https://github.com/wsdjeg/format.nvim/commit/ad2a3c10bc1b05f59c16b89f7dc69467091f778f))


### Bug Fixes

* fix default type ([3e69a0a](https://github.com/wsdjeg/format.nvim/commit/3e69a0a0dd662574abb89263c2816695382c4b1c))

## [1.2.0](https://github.com/wsdjeg/format.nvim/compare/v1.1.0...v1.2.0) (2025-09-10)


### Features

* **cmd:** add FormatWrite command ([8f8e20a](https://github.com/wsdjeg/format.nvim/commit/8f8e20af66801a237250ed3387ef162a025df7db))
* **core:** support format hooks ([e475bc5](https://github.com/wsdjeg/format.nvim/commit/e475bc58045e23fea3888b4e307373604c45eb81))
* **core:** support locking buffer ([01d646b](https://github.com/wsdjeg/format.nvim/commit/01d646b737d2fdb44aafea2128446a2049d56557))
* **core:** support timeout option ([dcb7267](https://github.com/wsdjeg/format.nvim/commit/dcb72674a86bb108a1ab1d4f812bd1496058311d))
* **formatter:** add gofmt for golang ([61fe2be](https://github.com/wsdjeg/format.nvim/commit/61fe2be46f797746d975a6316db2b72c943ce739))
* **formatter:** add yapf for python ([9fbd484](https://github.com/wsdjeg/format.nvim/commit/9fbd484fb97e60bda0db4abddadedc8279b48a30))


### Bug Fixes

* **hooks:** run hooks.post only when changed ([ce58787](https://github.com/wsdjeg/format.nvim/commit/ce58787e331dc135f642050d2515af65a06eed1c))

## [1.1.0](https://github.com/wsdjeg/format.nvim/compare/v1.0.0...v1.1.0) (2025-09-09)


### Features

* **core:** specific filetype and formatter ([efe04b2](https://github.com/wsdjeg/format.nvim/commit/efe04b223b524ee6fac8862a625bea4fefd2cb6a))
* **task:** support timeout ([7618555](https://github.com/wsdjeg/format.nvim/commit/76185558835645d9d9a2f6ad3741065d84dd1777))
* **types:** add format types ([3deb5e6](https://github.com/wsdjeg/format.nvim/commit/3deb5e657371f425bff9232aa3bebff2d7422af9))


### Bug Fixes

* **formatter:** remove exepath ([aa923b8](https://github.com/wsdjeg/format.nvim/commit/aa923b8459cddd6b808b38036f7bcc78b580cf56))

## 1.0.0 (2025-03-13)


### Features

* **core:** remove vim script ([ab557a8](https://github.com/wsdjeg/format.nvim/commit/ab557a82bcb7f3a4231ca363039ee694e2da2ea3))
* **easing:** use easing function in notify ([ba76ff1](https://github.com/wsdjeg/format.nvim/commit/ba76ff13e4e4dfa5334eb705a9ac80083008ffbd))
* **markdown:** add `SPC l f` to format code block ([83d58e1](https://github.com/wsdjeg/format.nvim/commit/83d58e16196cfebb0045dd6a5f7b51fe0c67c11f))
* **nvim-plug:** add new plugin manager ([47df959](https://github.com/wsdjeg/format.nvim/commit/47df959678ec4008be9e98083528bc56ac7389a8))
* **runtime:** add `--clear` to clear runtime log ([66fd463](https://github.com/wsdjeg/format.nvim/commit/66fd46311acc715d92682277299ee264db56c8a6))


### Bug Fixes

* **notify:** pcall viml notify ([24fe9b3](https://github.com/wsdjeg/format.nvim/commit/24fe9b3d4d31401af54c70714231d31b3dcd5e34))
