function run()
{
    for (var i = 0; i < serverList.length; i++)
    {
        if (!('pingPong' in serverList[i]['commandList']))
        {
            serverList[i]['commandList']['pingPong'] = []
        }
    }
}