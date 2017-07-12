/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

- (NSDictionary*)propertiesPlease {
    
    NSMutableDictionary* props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t* properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
         objc_property_t property    = properties[i];
         const char* propName        = property_getName(property);
         NSString* propertyName      = [NSString stringWithUTF8String:propName];
         id propertyValue            = [self valueForKey:propertyName];
        
         if (propertyValue)
            [props setObject:propertyValue forKey:propertyName];
    }
    
    free(properties);
    return props;
}

@end
