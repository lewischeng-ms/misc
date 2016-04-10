using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;

namespace WebApi
{
    public class ODataController : IDisposable
    {
        private IServiceScope scope;

        public ODataController()
        {
            IServiceProvider rootContainer = null; // Get container from some request context
            scope = rootContainer.GetService<IServiceScopeFactory>().CreateScope();
        }

        public void Dispose()
        {
            scope.Dispose();
        }

        public IServiceProvider Container
        {
            get { return this.scope.ServiceProvider; }
        }
    }
}
