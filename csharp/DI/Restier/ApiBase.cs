using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ODataLib;

namespace Restier
{
    public abstract class ApiBase
    {
        public static void ConfigureApi(IContainerBuilder builder)
        {
            // Register some default or convention-based services.
        }
    }
}
