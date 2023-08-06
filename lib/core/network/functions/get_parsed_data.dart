import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../failure/failure.dart';

List<int> successStatusCodes = [200, 201, 202, 204];

//THIS FUNCTION WORKS FOR SPICE ME UP, NEED TO MODIFY THIS FUNCTION AS PER THE PROJECT

Future<Either<T, Failure>> getParsedData<T>(
    Response? response, dynamic fromJson) async {
  if (response != null && successStatusCodes.contains(response.statusCode)) {
    //handle success here
    if (response.data is Map) {
      try {
        return Left(fromJson(response.data));
      } catch (e) {
        debugPrint("Error parsing data: $e");
        // return Right(Failure.fromJson({}));
        return Right(Failure.fromJson(response.data));
      }
    } else if (response.statusCode == 204) {
      // status code 204 means success but no response data
      return left(fromJson);
    } else {
      return Right(
        Failure.fromJson({}),
      );
    }
  } else {
    Map<String, dynamic>? failedRespData;
    try {
      failedRespData = response?.data;
    } catch (e) {
      debugPrint("Could not parse backend response as map");
      failedRespData = {};
    }

    return Right(
      Failure.fromJson(failedRespData ?? {}),
    );
  }
}
