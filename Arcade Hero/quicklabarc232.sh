gcloud config set compute/region $REGION
export PROJECT_ID=$(gcloud config get-value project)


mkdir quicklab && cd quicklab


cat > Function.cs <<'EOF_END'
using Google.Cloud.Functions.Framework;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;

namespace HelloWorld;

public class Function : IHttpFunction
{
    public async Task HandleAsync(HttpContext context)
    {
        await context.Response.WriteAsync("Hello World!", context.RequestAborted);
    }
}
EOF_END

cat > HelloHttp.csproj <<'EOF_END'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net6.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Google.Cloud.Functions.Hosting" Version="2.2.1" />
  </ItemGroup>
</Project>
EOF_END

#HelloHttp.Function entery point


  gcloud functions deploy cf-demo \
    --gen2 \
    --entry-point=HelloWorld.Function \
    --runtime=dotnet6 \
    --region=$REGION \
    --source=. \
    --trigger-http \
    --allow-unauthenticated \
    --quiet
