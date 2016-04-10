using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODataLib
{
    public static class ContainerBuilderExtensions
    {
        public static IContainerBuilder ConfigureODataServices(this IContainerBuilder builder)
        {
            builder.AddSingleton<ODataWriterValidator>();
            builder.AddScoped<ODataMessageWriter>();
            builder.AddScoped<ODataRequestContext>();
            return builder;
        }
    }
}
