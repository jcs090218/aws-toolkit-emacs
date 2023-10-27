;;; aws-lsp.el --- LSP related  -*- lexical-binding: t; -*-

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
;; LSP related
;;

;;; Code:

(defcustom aws-lsp-server-version "0.0.1"
  "The language server's version."
  :type 'string
  :group 'aws)

(defconst aws-lsp-server-root
  (f-join lsp-server-install-dir "aws-toolkit-common")
  "Root path to store all AWS language servers.")

(defconst aws-lsp-server-download-url
  (format
   "https://github.com/jcs090218/aws-toolkit-emacs/releases/download/%s/aws-toolkit-common.tar"
   aws-lsp-server-version)
  "Server download URL.")

(defun aws-lsp-install ()
  "Install language servers from `aws-toolkit-common'."
  (let* ((tar aws-codewhisperer-server-root)
         (dest (file-name-directory tar))
         (output (expand-file-name aws-lsp-server-root dest))
         (latest (expand-file-name "latest" (file-name-directory output)))
         (is-windows (eq system-type 'windows-nt)))
    (if (aws--execute "tar" "-xvzf" tar "-C" dest)
        (unless (aws--execute (if is-windows "move" "mv")
                              (unless is-windows "-f")
                              output latest)
          (error "[ERROR] Failed to rename version `aws-toolkit-common' to the latest"))
      (error "[ERROR] Failed to unzip tar, %s" tar))))

(provide 'aws-lsp)
;;; aws-lsp.el ends here
