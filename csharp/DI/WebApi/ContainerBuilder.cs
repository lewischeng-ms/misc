using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using ODataLib;

namespace WebApi
{
    internal class ContainerBuilder : IContainerBuilder
    {
        private IServiceCollection colletion = new ServiceCollection();

        public void AddSingleton<T>() where T : class
        {
            colletion.AddSingleton<T>();
        }

        public void AddScoped<T>() where T : class
        {
            colletion.AddScoped<T>();
        }

        public IServiceProvider Build()
        {
            return colletion.BuildServiceProvider();
        }
    }
}