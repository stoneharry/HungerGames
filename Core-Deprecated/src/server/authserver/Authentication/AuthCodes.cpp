/*
 * Copyright (C) 2008-2014 TrinityCore <http://www.trinitycore.org/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "AuthCodes.h"
#include <cstddef>

namespace AuthHelper
{
    static RealmBuildInfo const PostBcAcceptedClientBuilds[] =
    {
        {12340, 3, 3, 5, 'a'},
        {0,     0, 0, 0, ' '}                                   // terminator
    };

    static RealmBuildInfo const PreBcAcceptedClientBuilds[] =
    {
        {0,     0, 0, 0, ' '}                                   // terminator
    };

    bool IsPreBCAcceptedClientBuild(int build)
    {
        for (int i = 0; PreBcAcceptedClientBuilds[i].Build; ++i)
            if (PreBcAcceptedClientBuilds[i].Build == build)
                return true;

        return false;
    }

    bool IsPostBCAcceptedClientBuild(int build)
    {
        for (int i = 0; PostBcAcceptedClientBuilds[i].Build; ++i)
            if (PostBcAcceptedClientBuilds[i].Build == build)
                return true;

        return false;
    }

    bool IsAcceptedClientBuild(int build)
    {
        return (IsPostBCAcceptedClientBuild(build) || IsPreBCAcceptedClientBuild(build));
    }

    RealmBuildInfo const* GetBuildInfo(int build)
    {
        for (int i = 0; PostBcAcceptedClientBuilds[i].Build; ++i)
            if (PostBcAcceptedClientBuilds[i].Build == build)
                return &PostBcAcceptedClientBuilds[i];

        for (int i = 0; PreBcAcceptedClientBuilds[i].Build; ++i)
            if (PreBcAcceptedClientBuilds[i].Build == build)
                return &PreBcAcceptedClientBuilds[i];

        return NULL;
    }
};
