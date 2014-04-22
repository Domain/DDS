module main;

import std.stdio;
import std.getopt;
import std.file;
import std.path;
import std.exception;
import std.array;
import std.regex;
import std.algorithm;

import test.Test;

void generateAllFile(string dir, string prefix)
{
    enforce(dir.isDir());
    chdir(dir);
    auto path = relativePath(dir, prefix);
    path = path.replace("\\", ".");
    auto files = appender!string();
    foreach (entry; dirEntries(dir, SpanMode.shallow)) 
    { 
        if (entry.isFile() && entry.name.extension() == ".d")
        {
            auto filename = baseName(entry.name, ".d");

            if (filename != "package")
                files.put("public import " ~ path ~ "." ~ filename ~";\n");
        }
    }
    if (files.data != "")
    {
        auto f = File("package.d", "w");
        f.writeln("module " ~ path ~ ";\n");
        f.write(files.data);
        f.close();
    }
}

void generateMissingFiles(string filename, string base)
{
    auto content = std.file.readText(filename);

    auto modR = regex(`^\s*import\s*([_a-zA-Z][_a-zA-Z0-9]*(?:\.[_a-zA-Z][_a-zA-Z0-9]*)*)\s*;\s*$`, "gm");
    foreach (c; match(content, modR))
    {
        string modName = c[1];
        writeln(modName);
        string modFile = buildPath(base, modName.replace(".", dirSeparator)) ~ ".d";
        if (!exists(modFile))
        {
            if (!exists(dirName(modFile)))
                dirName(modFile).mkdirRecurse();
            auto className = modFile.baseName().stripExtension();
            auto app = appender!string();
            app.put("/// Generate by tools\n");
            app.put("module " ~ modName ~ ";\n");
            app.put("\n");
            app.put("import java.lang.exceptions;\n");
            app.put("\n");
            app.put("public class " ~ className ~ "\n");
            app.put("{\n");
            app.put("    public this()\n");
            app.put("    {\n");
            app.put("        implMissing();\n");
            app.put("    }\n");
            app.put("}\n");
            std.file.write(modFile, app.data);
        }
    }
}

void j2d(string filename, string jdir, string ddir)
{
    auto rpath = relativePath(filename, jdir);
    auto dname = ddir ~ rpath;

    if (!exists(dirName(dname)))
        dirName(dname).mkdirRecurse();

    if (filename.extension() != ".java")
    {
        copy(filename, dname);
        return;
    }

    auto src = File(filename, "r");
    scope(exit) src.close();
    auto content = appender!string();
    auto commentR = regex(`^/\*[\s:\d]*\*/ `, "g");
    foreach (line; src.byLine(KeepTerminator.yes))
    {
        auto newLine = line;
        newLine = std.regex.replace(newLine, commentR, "");
        if (newLine.startsWith("package "))
        {
            newLine = newLine.replace("package ", "module ");
            newLine = newLine.replace(";", "." ~ baseName(filename, ".java") ~ ";");
        }
        newLine = newLine.replace(" extends ", " : ");
        newLine = newLine.replace(" implements ", " : ");
        newLine = newLine.replace("@Override", "override");
        newLine = newLine.replace("== null", "is null");
        newLine = newLine.replace("!= null", "!is null");
        newLine = newLine.replace("boolean", "bool");
        newLine = newLine.replace("@Deprecated", "deprecated");
        newLine = newLine.replace(".debug(", ".debug_(");
        content.put(newLine);
    }

    auto text = content.data;

    auto ctorR = regex(`(\s*)(public|private|protected)(\s+)[_a-zA-Z][_a-zA-Z0-9]*(\s*)\(`, "g");
    text = std.regex.replace(text, ctorR, "$1$2$3this$4(");

    auto throwR = regex(`(\))\s*throws\s+[_a-zA-Z][_a-zA-Z0-9]*(?:\s*,\s*[_a-zA-Z][_a-zA-Z0-9]*)*(\s*)(\{|;)`, "g");
    text = std.regex.replace(text, throwR, "$1$2$3");

    auto subClassR = regex(`new\s+([_a-zA-Z][_a-zA-Z0-9]*)\s*(\([^\)]*\))\s*\{`, "g");
    text = std.regex.replace(text, subClassR, "new class$2 $1 {");

    auto hashR = regex(`\bint\b(\s*)hashCode(\s*\()`, "g");
    text = std.regex.replace(text, hashR, "override hash_t$1toHash$2");

    auto stringR = regex(`\bfinal\b(\s*)String(\s*)`, "g");
    text = std.regex.replace(text, stringR, "immutable String$2");

    auto equalsR = regex(`\bbool\b(\s*)equals(\s*\()`, "g");
    text = std.regex.replace(text, equalsR, "override equals_t$1opEquals$2");

    auto instanceofR = regex(`([\(,|&=])\s*([_a-zA-Z][\._a-zA-Z0-9\(\)]*)\s+instanceof\s+([_a-zA-Z][_a-zA-Z0-9]*)(\s*[),|&?])`, "g");
    text = std.regex.replace(text, instanceofR, "$1 cast($3)$2 !is null $4");

    auto outerR = regex(`\b[_a-zA-Z][_a-zA-Z0-9]*\.this\b`, "g");
    text = std.regex.replace(text, outerR, "this.outer");

    auto arrayR = regex(`new\s+([_a-zA-Z][\._a-zA-Z0-9]*\s*\[\s*\])\s*\{([^\}]*)\}`, "g");
    text = std.regex.replace(text, arrayR, "cast($1)[$2]");

    auto templDeclR = regex(`(class|interface)(\s+)([_a-zA-Z][_a-zA-Z0-9]*)<(\s*(?:[_a-zA-Z][_a-zA-Z0-9]*)(?:\s*,\s*[_a-zA-Z][_a-zA-Z0-9]*)*(?:\s+:\s+[_a-zA-Z][_a-zA-Z0-9]*)?\s*)*>`, "g");
    text = std.regex.replace(text, templDeclR, "$1$2$3($4)");

    //auto templR = regex(`<(\s*[_a-zA-Z\?][\.,0-9_a-zA-Z\s\?]*\s*)>`, "g");
    //text = std.regex.replace(text, templR, "!($1)");
    //
    //auto templR2 = regex(`<(\s*[_a-zA-Z\?][\.,0-9_a-zA-Z!\(\)\s\?]*(?::[_a-zA-Z][\.,0-9_a-zA-Z]*)\s*)>`, "g");
    //text = std.regex.replace(text, templR2, "!($1)");

    auto templR1 = regex(`<([_a-zA-Z0-9\s:!\(\)\?,\.]+?)>`, "g");
    text = std.regex.replace(text, templR1, "!($1)");

    auto templR2 = regex(`<([_a-zA-Z0-9\s:!\(\)\?,\.]+?)>`, "g");
    text = std.regex.replace(text, templR2, "!($1)");

    auto templR3 = regex(`<([_a-zA-Z0-9\s:!\(\)\?,\.]+?)>`, "g");
    text = std.regex.replace(text, templR3, "!($1)");

    auto loggerR = regex(`\.getLogger\(\s*(.+)\.class\s*\)`, "g");
    text = std.regex.replace(text, loggerR, ".getLogger!($1)");

    auto classR = regex(`\.class\b`, "g");
    text = std.regex.replace(text, classR, ".class_");

    auto deleteR = regex(`\bdelete\(`, "g");
    text = std.regex.replace(text, deleteR, "delete_(");

    auto staticThisR = regex(`static(\s*)\{`, "g");
    text = std.regex.replace(text, staticThisR, "static this()$1{");

    auto foreachR = regex(`for(\s*)\(([_a-zA-Z][_a-zA-Z0-9!\(\),\s\[\]\?]*\s+[_a-zA-Z][_a-zA-Z0-9]*\s*):(\s*[_a-zA-Z][_a-zA-Z0-9\.!\(\),\s\[\]]*)\)`, "g");
    text = std.regex.replace(text, foreachR, "foreach$1($2;$3)");

    auto questionR = regex(`!\([^\)]*\?[^\)]*\)`, "g");
    text = std.regex.replace(text, questionR, "/*$&*/");

    //auto newCallR = regex(`(new\s+[_a-zA-Z][_a-zA-Z0-9]*\((?:[_a-zA-Z0-9\-]*)?\))\.`, "g");
    //text = std.regex.replace(text, newCallR, "($1).");

    auto digitR = regex(`(\d+\.\d+)D`, "g");
    text = std.regex.replace(text, digitR, "$1");

    auto multiR = regex(`class(\s+[_a-zA-Z][_a-zA-Z0-9]*(?:\(.+\))?\s*):(\s*[_a-zA-Z][_a-zA-Z0-9]*(?:!\([_a-zA-Z][_a-zA-Z0-9]*(?:\s*,\s*[_a-zA-Z][_a-zA-Z0-9]*)?\))?\s*):(\s*[_a-zA-Z][_a-zA-Z0-9]*)`, "g");
    text = std.regex.replace(text, multiR, "class$1:$2,$3");

    auto castR = regex(`(return\s+|[\(,|&=:])(\s*)(\(\s*(?:[_a-zA-Z][_a-zA-Z0-9]*(?:\.[_a-zA-Z][_a-zA-Z0-9]*)?)\s*(?:\[\s*\]\s*)?(?:!\([_a-zA-Z][_a-zA-Z0-9]*\))?\))(\s*[_a-zA-Z])`, "g");
    text = std.regex.replace(text, castR, "$1$2cast$3$4");

    auto warningR = regex(`@SuppressWarnings\(".*"\)`, "g");
    text = std.regex.replace(text, warningR, "");

    auto volatileR = regex(`\bvolatile\b`, "g");
    text = std.regex.replace(text, volatileR, "/*volatile*/");

    // Bug for jd-gui
    auto iDollarR = regex(`i\$`, "g");
    text = std.regex.replace(text, iDollarR, "i");

    auto enumR = regex(`(enum\s+[_a-zA-Z][_a-zA-Z0-9]*\s*\{\s*[_a-zA-Z][_a-zA-Z0-9]*(?:\s*,\s*[_a-zA-Z][_a-zA-Z0-9]*)*);(\s*\})`, "g");
    text = std.regex.replace(text, enumR, "$1$2");

    dname = dname.replace(".java", ".d");
    std.file.write(dname, text);

    return;
}

void printHelp()
{
}

void testObject(Object obj)
{
}

void testCod()
{
    testObject("string");
    T t = new T2();
    t.bar();
    //Test t = new Test();
    //t.foo(0);
}

int main(string[] argv)
{
    string jdir;
    string ddir;

    bool convert = false;
    bool genAll = false;
    bool genMissing = false;
    bool showHelp = false;
    bool testCode = false;

    try
    {
        getopt(argv, 
               "javadir|j", &jdir,
               "ddir|d", &ddir,
               std.getopt.config.bundling,
               "convert|c", &convert,
               "genAll|a", &genAll,
               "genMissing|m", &genMissing,
               "help|h", &showHelp,
               "test|t", &testCode);
    }
    catch(Exception e)
    {
        writeln(e.msg);
    }

    if (argv.length > 1)
    {
        writeln("Unrecognized option: ", argv[1..$]);
        return 1;
    }

    if (testCode)
    {
        testCod();
        return 0;
    }

    if (!convert && !genAll && !genMissing)
    {
        writeln("At least specify one option: convert(c), genAll(a), genMissing(m)");
        return 2;
    }

    if (convert && (jdir == "" || ddir == ""))
    {
        writeln("Missing dir.");
        printHelp();
        return 2;
    }

    if (genAll && ddir == "")
    {
        writeln("Missing dir.");
        printHelp();
        return 2;
    }

    if (genMissing && ddir == "")
    {
        writeln("Missing dir.");
        printHelp();
        return 2;
    }

    if (!jdir.endsWith(dirSeparator))
        jdir ~= dirSeparator;

    if (!ddir.endsWith(dirSeparator))
        ddir ~= dirSeparator;

    if (convert)
    {
        foreach (entry; dirEntries(jdir, SpanMode.depth)) 
        { 
            if (entry.isFile())
            {
                writeln("processing " ~ entry.name ~ " ...");
                j2d(entry.name, jdir, ddir);
            }
        }
    }

    if (genAll)
    {
        foreach (entry; dirEntries(ddir, SpanMode.depth)) 
        { 
            if (entry.isDir())
            {
                generateAllFile(entry.name, ddir);
            }
        }
    }

    if (genMissing)
    {
        foreach (entry; dirEntries(ddir, SpanMode.depth)) 
        { 
            if (entry.isFile() && entry.name.extension() == ".d")
            {
                generateMissingFiles(entry.name, ddir);
            }
        }
    }

    return 0;
}
