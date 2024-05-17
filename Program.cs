// See https://aka.ms/new-console-template for more information
using System;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello, World!");
        var platform = Environment.OSVersion.Platform;
        var os = Environment.OSVersion.VersionString;
        var architecture = System.Runtime.InteropServices.RuntimeInformation.ProcessArchitecture;
    string runtimeIdentifier = args.Length > 0 ? args[0] : System.Runtime.InteropServices.RuntimeInformation.RuntimeIdentifier;
        Console.WriteLine($"Platform: {platform}");
        Console.WriteLine($"Operating System: {os}");
        Console.WriteLine($"CPU Architecture: {architecture}");
        Console.WriteLine($"Runtime Identifier: {runtimeIdentifier}");
        bool isMusl = System.Runtime.InteropServices.RuntimeInformation.OSDescription.Contains("musl");
        bool isGlibc = System.Runtime.InteropServices.RuntimeInformation.OSDescription.Contains("glibc");

        if (isMusl)
        {
            Console.WriteLine("Using musl");
        }
        else if (isGlibc)
        {
            Console.WriteLine("Using glibc");
        }
        else
        {
            Console.WriteLine("Unknown libc");
        }
            Console.WriteLine("Runtime Information:");
    Console.WriteLine($"Framework Description: {System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription}");
    Console.WriteLine($"OS Architecture: {System.Runtime.InteropServices.RuntimeInformation.OSArchitecture}");
    Console.WriteLine($"Process Architecture: {System.Runtime.InteropServices.RuntimeInformation.ProcessArchitecture}");
    Console.WriteLine($"Runtime Identifier: {System.Runtime.InteropServices.RuntimeInformation.RuntimeIdentifier}");
    // Console.WriteLine($"Is OS Windows: {System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.Windows)}");
    // Console.WriteLine($"Is OS Linux: {System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.Linux)}");
    // Console.WriteLine($"Is OS macOS: {System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(OSPlatform.OSX)}");
    
    Console.WriteLine($"Target Runtime: {runtimeIdentifier}");

    
    }

}
