using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ODataLib;

namespace WebApi
{
    public class Startup
    {
        public static void MapODataRoute(Action<IContainerBuilder> configure)
        {
            var builder = new ContainerBuilder();
            builder.ConfigureODataServices();
            // Register some services from Web API.
            configure(builder); // Register user services.
            var container = builder.Build();
            // put container into some place like ODataRoute, RouteConstraints
        }
    }
}
