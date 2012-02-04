using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ExeExample
{
    class Program
    {
        AppDomain domain;
        AssemblyName name;
        AssemblyBuilder asmbuilder;
        ModuleBuilder modbuilder;
        TypeBuilder typbuilder;
        FieldInfo fld;
        MethodBuilder addBuilder;
        MethodBuilder mainBuilder;
        MethodBuilder factBuilder;
        ILGenerator iladd;
        ILGenerator ilfact;
        ILGenerator ilmain;
        
        // 参数必须已经被压入栈中！
        void CallMethod(ILGenerator ilgen, MethodInfo met)
        {
            ilgen.Emit(OpCodes.Call, met);
        }

        void PushString(ILGenerator ilgen, string str)
        {
            ilgen.Emit(OpCodes.Ldstr, str);
        }

        void PushNum(ILGenerator ilgen, long value)
        {
            switch (value)
            {
                case 0:
                    ilgen.Emit(OpCodes.Ldc_I4_0);
                    break;
                case 1:
                    ilgen.Emit(OpCodes.Ldc_I4_1);
                    break;
                case 2:
                    ilgen.Emit(OpCodes.Ldc_I4_2);
                    break;
                case 3:
                    ilgen.Emit(OpCodes.Ldc_I4_3);
                    break;
                case 4:
                    ilgen.Emit(OpCodes.Ldc_I4_4);
                    break;
                case 5:
                    ilgen.Emit(OpCodes.Ldc_I4_5);
                    break;
                case 6:
                    ilgen.Emit(OpCodes.Ldc_I4_6);
                    break;
                case 7:
                    ilgen.Emit(OpCodes.Ldc_I4_7);
                    break;
                case 8:
                    ilgen.Emit(OpCodes.Ldc_I4_8);
                    break;
                default:
                    if (value > SByte.MinValue && value < SByte.MaxValue)
                        ilgen.Emit(OpCodes.Ldc_I4_S, (byte)value);
                    else if (value > Int32.MinValue && value < Int32.MaxValue)
                        ilgen.Emit(OpCodes.Ldc_I4, (int)value);
                    else
                        ilgen.Emit(OpCodes.Ldc_I8, value);
                    break;
            }
        }

        void GenerateCodeForMain()
        {
            // 创建局部变量var1
            LocalBuilder var1 = ilmain.DeclareLocal(typeof(int));

            // 调用Add函数
            PushNum(ilmain, 5);
            PushNum(ilmain, 6);
            CallMethod(ilmain, addBuilder);
            ilmain.Emit(OpCodes.Stloc, var1);

            PushString(ilmain, "The number is {0}.");
            ilmain.Emit(OpCodes.Ldloc, var1);
            // 对值类型装箱
            ilmain.Emit(OpCodes.Box, typeof(int));
            CallMethod(ilmain, typeof(Console).GetMethod("WriteLine", new Type[]{ typeof(string), typeof(object) }));

            // 调用阶乘函数
            PushNum(ilmain, 10);
            CallMethod(ilmain, factBuilder);
            CallMethod(ilmain, typeof(Console).GetMethod("WriteLine", new Type[] { typeof(int) }));

            CallMethod(ilmain, typeof(Console).GetMethod("Read"));

            ilmain.Emit(OpCodes.Ret);
        }

        void GenerateCodeForAdd()
        {
            // 对参数0作加法
            iladd.Emit(OpCodes.Ldarg, 0);
            // ilfact.Emit(OpCodes.Ldarg_S, (byte)0);
            iladd.Emit(OpCodes.Ldc_I4_1);
            iladd.Emit(OpCodes.Add);

            // 结果存到全局变量里
            iladd.Emit(OpCodes.Stsfld, fld);
            iladd.Emit(OpCodes.Ldsfld, fld);
            
            // 读入参数1
            iladd.Emit(OpCodes.Ldarg_1);

            // 做加法
            iladd.Emit(OpCodes.Add);

            iladd.Emit(OpCodes.Ret);
        }

        void GenerateCodeForFact()
        {
            LocalBuilder res = ilfact.DeclareLocal(typeof(int));
            Label recursive = ilfact.DefineLabel();
            ilfact.Emit(OpCodes.Ldarg_0);
            ilfact.Emit(OpCodes.Ldc_I4_1);
            ilfact.Emit(OpCodes.Bgt, recursive);
            ilfact.Emit(OpCodes.Ldc_I4_1);
            ilfact.Emit(OpCodes.Ret);
            ilfact.MarkLabel(recursive);
            ilfact.Emit(OpCodes.Ldarg_0);
            ilfact.Emit(OpCodes.Ldc_I4_1);
            ilfact.Emit(OpCodes.Sub);
            ilfact.Emit(OpCodes.Call, factBuilder);
            ilfact.Emit(OpCodes.Ldarg_0);
            ilfact.Emit(OpCodes.Mul);
            ilfact.Emit(OpCodes.Ret);
        }

        public void GenerateExe()
        {
            string AssemblyName = "TestAssembly";
            string ClassName = "TestClass";
            string ExeName = ClassName + ".exe";

            // 获得应用程序域，用于创建程序集。
            domain = Thread.GetDomain();

            // 创建程序集名称。
            name = new AssemblyName();
            name.Name = AssemblyName;

            // 创建程序集。
            asmbuilder = domain.DefineDynamicAssembly(name, AssemblyBuilderAccess.RunAndSave);

            // 创建模块。
            modbuilder = asmbuilder.DefineDynamicModule(ExeName);

            // 创建类型。
            typbuilder = modbuilder.DefineType(ClassName);

            // 创建全局变量（类的静态变量）
            fld = typbuilder.DefineField("haha", typeof(int), FieldAttributes.Static);

            // 创建静态方法Add：public static int Add(int,int)
            addBuilder = typbuilder.DefineMethod("Add", MethodAttributes.Public | MethodAttributes.Static, typeof(int), new Type[] { typeof(int), typeof(int) });

            // 创建静态方法Add：public static int Fact(int)
            factBuilder = typbuilder.DefineMethod("Fact", MethodAttributes.Public | MethodAttributes.Static, typeof(int), new Type[] { typeof(int) });

            // 创建静态方法Main：public static void Main(string[])
            mainBuilder = typbuilder.DefineMethod("Main", MethodAttributes.Public | MethodAttributes.Static, typeof(void), new Type[] { typeof(string[]) });

            // Add方法的代码生成器
            iladd = addBuilder.GetILGenerator();

            // 产生Add方法的代码
            GenerateCodeForAdd();

            // Fact方法的代码生成器
            ilfact = factBuilder.GetILGenerator();

            // 产生Fact方法的代码
            GenerateCodeForFact();

            // Main方法的代码生成器
            ilmain = mainBuilder.GetILGenerator();

            // 产生Main方法的代码。
            GenerateCodeForMain();

            // 类里所有东西都已经定义好了，现在要创建这个类。
            typbuilder.CreateType();

            // 设置入口点。
            asmbuilder.SetEntryPoint((modbuilder.GetType(ClassName)).GetMethod("Main"));

            // 保存到EXE文件。
            asmbuilder.Save(ExeName);
        }

        static void Main(string[] args)
        {
            new Program().GenerateExe();
        }
    }
}
