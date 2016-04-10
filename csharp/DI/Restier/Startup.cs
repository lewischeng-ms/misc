using ODataLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebApi;

namespace Restier
{
    public class Startup
    {
        public static void MapRestierRoute<TApi>(Action<IContainerBuilder> configure)
            where TApi : ApiBase
        {
            WebApi.Startup.MapODataRoute(builder =>
            {
                // Register some default/convention-based services
                ApiBase.ConfigureApi(builder);

                // Register the services from API
                // should be: builder.AddScoped<ApiBase, TApi>();
                builder.AddScoped<TApi>();

                // Let user register some custom services
                configure(builder);
            });
        }

        public static void Sample()
        {
            MapRestierRoute<MyApi>(builder =>
            {
                // builder.ConfigureEf(); // From EF provider
                // builder.ChainPrevious<IModelBuilder, MyModelBuilder>();
            });
        }
    }
}
