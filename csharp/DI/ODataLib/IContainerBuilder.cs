using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ODataLib
{
    // As a side effect, this also supports any third party DI container.
    public interface IContainerBuilder
    {
        // Copy from DI's ServiceCollectionExtensions
        // Another possible solution: Use enum Lifetime.Scoped, Lifetime.Singleton, Lifetime.Transient
        // thus we can eliminate many duplicate methods here:
        //     void AddService<T>(Lifetime lifetime)
        //     void AddService(Lifetime lifetime, Type serviceType)
        //     void AddService<T>(Lifetime lifetime, Func<T> factory)
        void AddSingleton<T>() where T : class;
        void AddScoped<T>() where T : class;

        IServiceProvider Build();
    }
}
