using System;
using System.IO;
using System.Text;

namespace LicenseReplacer
{
    enum Language
    {
        Unknown,
        C,
        Vb
    }

    class License
    {
        private readonly string _text;
        private readonly Language _language;
        private readonly string _filename;
        private int _position;

        private const string Template =
@"{1}---------------------------------------------------------------------
{1} <copyright file=""{0}"" company=""Microsoft"">
{1}      Copyright (C) Microsoft Corporation. All rights reserved. See License.txt in the project root for license information.
{1} </copyright>
{1}---------------------------------------------------------------------

";

        public License(string text, Language language, string filename)
        {
            _text = text;
            _language = language;
            _filename = filename;
        }

        public string Modify()
        {
            SkipWhitespaces();

            SkipExistingLicense();

            if (IsGeneratedFile())
            {
                return _text;
            }

            SkipWhitespaces();

            if (_position >= _text.Length)
            {
                return GetLicenseText();
            }

            return GetLicenseText() + _text.Substring(_position);
        }

        private bool IsGeneratedFile()
        {
            var currentLicense = _position >= _text.Length ? _text : _text.Substring(0, _position + 1);
            if (currentLicense.ToLowerInvariant().Contains("generated"))
            {
                return true;
            }

            if (_filename.EndsWith(".designer.cs", StringComparison.InvariantCultureIgnoreCase))
            {
                return true;
            }

            return false;
        }

        private void SkipWhitespaces()
        {
            while (Char.IsWhiteSpace(_text[_position]) && _position < _text.Length)
            {
                ++_position;
            }
        }

        private void SkipExistingLicense()
        {
            if (_language == Language.C)
            {
                SkipCComments();
            }
            else if (_language == Language.Vb)
            {
                SkipVbComments();
            }
        }

        private void SkipCComments()
        {
            if (IsStartOfCComment(false))
            {
                SkipToEndOfCBlockComment();
            }
            else
            {
                while (IsStartOfCComment(true))
                {
                    SkipToEndOfLine();
                }
            }
        }

        private void SkipVbComments()
        {
            while (IsStartOfVbComment())
            {
                SkipToEndOfLine();
            }
        }

        private void SkipToEndOfLine()
        {
            while (_position < _text.Length && !IsEndOfLine(_text[_position]))
            {
                ++_position;
            }

            if (_position >= _text.Length)
            {
                return;
            }

            if (_text[_position] == '\r')
            {
                _position += 2;
            }
            else if (_text[_position] == '\n')
            {
                ++_position;
            }
        }

        private void SkipToEndOfCBlockComment()
        {
            while (_position < _text.Length)
            {
                if (_text[_position] == '*')
                {
                    if (_position + 1 < _text.Length && _text[_position + 1] == '/')
                    {
                        _position += 2;
                        return;
                    }
                }

                ++_position;
            }
        }

        private bool IsStartOfCComment(bool isLineComment)
        {
            if (_position >= _text.Length)
            {
                return false;
            }

            if (_text[_position] == '/')
            {
                var starter = isLineComment ? '/' : '*';
                if (_position + 1 < _text.Length && _text[_position + 1] == starter)
                {
                    return true;
                }
            }

            return false;
        }

        private bool IsStartOfVbComment()
        {
            if (_position >= _text.Length)
            {
                return false;
            }

            return _text[_position] == '\'';
        }

        private string GetLicenseText()
        {
            string starter = null;
            if (_language == Language.C)
            {
                starter = "//";
            }
            else if (_language == Language.Vb)
            {
                starter = "'";
            }

            return string.Format(Template, _filename, starter);
        }

        private static bool IsEndOfLine(char c)
        {
            return c == '\r' || c == '\n';
        }
    }

    class Program
    {
        private readonly string _path;
        private readonly string _extension;
        private readonly Language _language;

        public Program(string path, string extension)
        {
            _path = path;
            _extension = extension;
            _language = ValidateExtension(_extension);
        }

        public void Process()
        {
            var dir = new DirectoryInfo(_path);
            var pattern = string.Format("*.{0}", _extension);
            var sourceFiles = dir.EnumerateFiles(pattern, SearchOption.AllDirectories);
            foreach (var sourceFile in sourceFiles)
            {
                Console.WriteLine("Processing {0}...", sourceFile.FullName);

                if (sourceFile.Length == 0)
                {
                    Console.WriteLine("Empty file ignored.");
                    continue;
                }

                ProcessSourceFile(sourceFile);
            }
        }

        private void ProcessSourceFile(FileInfo file)
        {
            var reader = file.OpenText();
            var text = reader.ReadToEnd();
            reader.Close();
            var modifiedText = new License(text, _language, file.Name).Modify();
            if (text != modifiedText)
            {
                var writer = new StreamWriter(file.Open(FileMode.Truncate), Encoding.UTF8);
                writer.Write(modifiedText);
                writer.Close();
            }
        }

        private static Language ValidateExtension(string extension)
        {
            switch (extension)
            {
            case "cpp":
            case "cs":
            case "h":
                return Language.C;
            case "vb":
                return Language.Vb;
            default:
                return Language.Unknown;
            }
        }

        private static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.WriteLine("Usage: LicenseReplacer.exe <path> <extension>");
                return;
            }

            new Program(args[0], args[1]).Process();
        }
    }
}
