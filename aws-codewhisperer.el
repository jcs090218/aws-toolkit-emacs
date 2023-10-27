;;; aws-codewhisperer.el --- AI Code Generator  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Shen, Jen-Chieh

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; AI Code Generator
;;

;;; Code:

(require 'aws)
(require 'aws-lsp)

(defconst aws-codewhisperer-executable
  (concat "aws-lsp-codewhisperer-binary-"
          (pcase system-type
            ('windows-nt                        "win.exe")
            ('darwin                            "macos")
            ((or 'gnu 'gnu/linux 'gnu/kfreebsd) "linux")))
  "Name of the AWS Codewhisperer executable.")

(defun aws-codewhisperer--server-command ()
  "Generate startup command for Codewhisperer."
  (list (if (file-exists-p aws-codewhisperer-server-path)
            aws-codewhisperer-server-path
          (f-join aws-codewhisperer-server-path
                  "aws-lsp-codewhisperer-binary"
                  "bin"
                  aws-codewhisperer-executable))
        "--stdio"))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection #'aws-codewhisperer--server-command)
  :priority -1
  :activation-fn (lsp-activate-on "codewhisperer")
  :add-on? t
  :server-id 'codewhisperer
  :download-server-fn
  (lambda (_client callback error-callback _update?)
    (lsp-package-ensure 'codewhisperer #'aws-codewhisperer-install-ls error-callback))))

(provide 'aws-codewhisperer)
;;; aws-codewhisperer.el ends here
